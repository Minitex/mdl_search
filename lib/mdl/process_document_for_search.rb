module MDL
  class ProcessDocumentForSearch
    TMP_DIR = File.exists?('/swadm/tmp') ? '/swadm/tmp' : Dir.tmpdir
    ###
    # Glue that connects an IIIF canvas, the image it represents,
    # and the OCR process we need to perform.
    OCRCandidate = Struct.new(:canvas_id, :image_url) do
      attr_accessor :image_file

      def image_filename_parts
        ext = image_url.split('.').last
        [uuid, ext]
      end

      def ocr_temp_file_path
        @ocr_temp_file_path ||= begin
          Pathname.new(TMP_DIR).join("mdl_tesseract_#{uuid}").to_s
        end
      end

      def ocr_output_file_path
        "#{ocr_temp_file_path}.hocr"
      end

      def uuid
        @uuid ||= SecureRandom.uuid
      end
    end

    class << self
      def call(identifier)
        new(identifier).call
      end
    end

    attr_reader :identifier, :logger
    attr_accessor :ocr_candidates

    def initialize(identifier, logger: Rails.logger)
      @identifier = identifier # ex. pch:1224
      @logger = logger
    end

    def call
      download_images
      run_ocr
      lines = parse_ocr
      write(lines)
      log('Finished')
    ensure
      cleanup_tempfiles
    end

    private

    def download_images
      with_connection do |conn|
        manifest = fetch_manifest(conn)
        self.ocr_candidates = build_ocr_candidates(manifest)
        log("Downloading #{ocr_candidates.size} image(s)")
        ocr_candidates.each do |candidate|
          candidate.image_file = download(candidate, conn)
        end
      end
    end

    def run_ocr
      ocr_candidates.each { |candidate| run_ocr_on(candidate) }
    end

    ###
    # Build array of +line+ hashes
    # {
    #   id: '',
    #   item_id: 'pcr:1224',
    #   ocr_line_id: '',
    #   line: 'the text of the line',
    #   canvas_id: 'https://contentdm....',
    #   word_boundaries: JSON.generate({
    #     "0": {
    #       "word": "the",
    #       "x0": 442,
    #       "y0": 445,
    #       "x1": 503,
    #       "y1": 482
    #     },
    #     "1": {
    #       "word": "text",
    #       "x0": 542,
    #       "y0": 443,
    #       "x1": 666,
    #       "y1": 482
    #     }
    #   })
    # }
    def parse_ocr
      log("Parsing OCR for #{ocr_candidates.count} image(s)")
      ocr_candidates.flat_map do |candidate|
        doc = Nokogiri::HTML(File.read(candidate.ocr_output_file_path))
        doc.css('.ocr_line').map.with_index do |ocr_line, idx|
          words = ocr_line.css('.ocrx_word')
          {
            id: "#{candidate.uuid}-#{idx}",
            item_id: identifier,
            line: words.map(&:text).join(' '),
            ocr_line_id: '', # do we need this field?
            canvas_id: candidate.canvas_id,
            word_boundaries: JSON.generate(
              words.each_with_index.reduce({}) do |acc, (word, i)|
                acc[i] = parse_hocr_title(word['title'])
                acc
              end
            )
          }
        end
      end
    end

    # Credit to Ocracoke for this one
    def parse_hocr_title(title)
      parts = title.split(';').map(&:strip)
      info = {}
      parts.each do |part|
        sections = part.split(' ')
        sections.shift
        if /^bbox/.match(part)
          x0, y0, x1, y1 = sections
          info['x0'], info['y0'], info['x1'], info['y1'] = [x0.to_i, y0.to_i, x1.to_i, y1.to_i]
        elsif /^x_wconf/.match(part)
          c = sections.first
          info['c'] = c.to_i
        end
      end
      info
    end

    def write(docs)
      log("Adding #{docs.size} docs to Solr")
      solr_client = RSolr.connect(url: IIIF_SEARCH_SOLR_URL)
      solr_client.delete_by_query("item_id:\"#{identifier}\"")
      solr_client.add(docs)
      solr_client.commit
    end

    def with_connection(&block)
      Net::HTTP.start(
        manifest_uri.host,
        manifest_uri.port,
        use_ssl: true,
        &block
      )
    end

    def download(candidate, http_connection)
      uri = URI(candidate.image_url)
      req = Net::HTTP::Get.new(uri)
      response = http_connection.request(req)
      if response.code == '200'
        Tempfile.new(
          candidate.image_filename_parts,
          TMP_DIR,
          mode: File::Constants::BINARY,
          encoding: 'ascii-8bit'
        ).tap do |file|
          file << response.body
          file.rewind
        end
      else
        raise "failed to fetch image #{candidate.image_url}"
      end
    end

    def build_ocr_candidates(manifest)
      manifest['sequences'][0]['canvases'].map do |c|
        OCRCandidate.new(c['@id'], c['images'][0]['resource']['@id'])
      end
    end

    def fetch_manifest(http_connection)
      @manifest ||= begin
        log("Fetching manifest at #{manifest_uri}")
        req = Net::HTTP::Get.new(manifest_uri)
        response = http_connection.request(req)
        if response.code == '200'
          JSON.parse(response.body)
        else
          raise 'Failed to fetch manifest'
        end
      end
    end

    def manifest_uri
      URI::HTTPS.build(
        host: 'cdm16022.contentdm.oclc.org',
        path: "/iiif/2/#{identifier}/manifest.json"
      )
    end

    def run_ocr_on(candidate)
      log("Running OCR for canvas #{candidate.canvas_id}")
      env = { 'OMP_THREAD_LIMIT' => '1' }
      command = "tesseract #{candidate.image_file.path} #{candidate.ocr_temp_file_path} -l eng hocr"
      _output, error, status = Open3.capture3(env, command)
      if status.success?
        log("OCR successful for image on canvas #{candidate.canvas_id}")
      else
        log_error("OCR failed for image on canvas #{candidate.canvas_id}")
        log_error(error)
      end
    end

    def cleanup_tempfiles
      Array(ocr_candidates).each do |candidate|
        if candidate.image_file
          candidate.image_file.close
          candidate.image_file.unlink
        end
        if File.exist?(candidate.ocr_output_file_path)
          File.unlink(candidate.ocr_output_file_path)
        end
      end
    end

    def log(msg)
      logger.info(format_log(msg))
    end

    def log_error(msg)
      logger.error(format_log(msg))
    end

    def format_log(msg)
      "[#{identifier}] #{msg}"
    end
  end
end
