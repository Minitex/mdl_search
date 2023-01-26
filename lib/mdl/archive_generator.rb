require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'async/http/internet/instance'
require 'zip'

module MDL
  class ArchiveGenerator
    TMP_DIR = File.exists?('/swadm/tmp') ? '/swadm/tmp' : Dir.tmpdir

    def self.call(identifier)
      new(identifier).call
    end

    attr_reader :identifier, :logger

    def initialize(identifier, logger: Rails.logger)
      @identifier = identifier
      @logger = logger
    end

    def call
      create_working_directory
      image_urls = gather_image_urls
      download_images(image_urls)
      create_archive
      zip_file_path
    ensure
      remove_working_directory
    end

    private

    def create_working_directory
      if File.exist?(work_dir)
        raise "working directory already exists for identifier #{identifier}"
      end
      if File.exist?(zip_file_path)
        raise "archive already exists for #{identifier}"
      end
      FileUtils.mkdir_p(work_dir)
    end

    def remove_working_directory
      FileUtils.rm_r(work_dir) if File.exist?(work_dir)
    end

    # Replace the full resolution URL with one that will return
    # the image bounded to 800px wide
    def gather_image_urls
      manifest = fetch_manifest
      manifest['sequences'][0]['canvases'].map do |c|
        c['images'][0]['resource']['@id'].sub('/full/full', '/full/800,')
      end
    end

    def fetch_manifest
      log("Fetching manifest for #{identifier}")

      task = Async do
        internet = Async::HTTP::Internet.instance
        url = "https://cdm16022.contentdm.oclc.org/iiif/2/#{identifier}/manifest.json"
        response = internet.get(url)
        if response.status == 200
          JSON.parse(response.read)
        else
          log_error("Failed to fetch manifest. Response status: #{response.status}")
          raise 'Failed to fetch manifest'
        end
      ensure
        internet&.close
      end

      task.wait
    end

    def download_images(urls)
      log "downloading #{urls.size} images to #{work_dir}"
      Async do
        internet = Async::HTTP::Internet.instance # persistent connection
        barrier = Async::Barrier.new
        semaphore = Async::Semaphore.new(8, parent: barrier)

        digits = urls.size.to_s.size
        urls.each_with_index do |url, idx|
          semaphore.async do
            ext = url.split('.').last
            # zero-pad the filename so that the files are correctly
            # ordered within the zip
            basename = idx.to_s.rjust(digits, '0')
            filename = File.join(work_dir, "#{basename}.#{ext}")
            response = internet.get(url)
            response.save(filename, 'wb') if response.success?
          end
        end

        barrier.wait
      ensure
        internet&.close
      end
    end

    def create_archive
      log "writing to #{zip_file_path}"
      Zip::File.open(zip_file_path, create: true) do |zip_file|
        Dir[File.join(work_dir, '**')].each do |download|
          entry_name = download.sub(archives_dir + File::Separator, '')
          zip_file.add(entry_name, download)
        end
      end
    rescue => e
      ###
      # If something goes wrong, delete the zip file so a subsequent retry
      # can start fresh.
      File.delete(zip_file_path)
      raise e
    end

    def zip_file_path
      work_dir + '.zip'
    end

    def work_dir
      File.join(archives_dir, identifier)
    end

    def archives_dir
      File.join(TMP_DIR, 'archives')
    end

    def log(msg)
      logger.info(format_log(msg))
    end

    def log_error(msg)
      logger.error(format_log(msg))
    end

    def format_log(msg)
      "#{self.class.name} [#{identifier}] : #{msg}"
    end
  end
end
