module MDL
  class ProcessDocumentForSearch
    Canvas = Struct.new(:id, :image_url) do
      def image_filename
        ext = image_url.split('.').last
        "#{ocr_output}.#{ext}"
      end

      def ocr_output
        self.hash.abs
      end
    end

    attr_reader :collection, :id, :directory
    attr_accessor :canvases

    def initialize(identifier)
      @collection, @id = identifier.split(':')
      @directory = Rails.root.join('tmp', identifier)
    end

    def call
      prep_work_dir
      download_images
      ocr
      lines = parse_ocr
      write(lines)
    end

    private

    def prep_work_dir
      FileUtils.mkdir_p(directory)
      FileUtils.cd(directory)
    end

    def download_images
      with_connection do |conn|
        manifest = fetch_manifest(conn)
        self.canvases = build_canvases(manifest)
        canvases.each do |canvas|
          download(canvas, conn)
        end
      end
    end

    def ocr
      canvases.each { |canvas| run_ocr(canvas) }
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
      canvases.flat_map do |canvas|
        doc = Nokogiri::HTML(File.read("#{canvas.ocr_output}.hocr"))
        doc.css('.ocr_line').map.with_index do |ocr_line, idx|
          words = ocr_line.css('.ocrx_word')
          line = {
            id: "#{canvas.ocr_output}-#{idx}",
            item_id: "#{collection}:#{id}",
            line: words.map(&:text).join(' '),
            ocr_line_id: '', # do we need this field?
            canvas_id: canvas.id,
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
      solr_client = RSolr.connect(url: 'http://localhost:8983/solr/mdl-iiif-search')
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

    def download(canvas, http_connection)
      uri = URI(canvas.image_url)
      req = Net::HTTP::Get.new(uri)
      response = http_connection.request(req)
      if response.code == '200'
        file_ext = uri.path.split('.').last
        File.open(canvas.image_filename, 'wb') do |file|
          file << response.body
        end
      else
        raise "failed to fetch image #{canvas.image_url}"
      end
    end

    def build_canvases(manifest)
      manifest['sequences'][0]['canvases'].map do |c|
        Canvas.new(c['@id'], c['images'][0]['resource']['@id'])
      end
    end

    def fetch_manifest(http_connection)
      @manifest ||= begin
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
        path: "/iiif/2/#{collection}:#{id}/manifest.json"
      )
    end

    def run_ocr(canvas)
      `tesseract #{canvas.image_filename} #{canvas.ocr_output} -l eng hocr`
    end
  end
end
