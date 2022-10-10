module MDL
  class ArchiveUploader
    BUCKET = 'files.mndigital.org'

    def self.call(archive_path)
      new(archive_path).call
    end

    attr_reader :archive_path, :logger

    def initialize(archive_path, logger: Rails.logger)
      @archive_path = archive_path
      @logger = logger
    end

    def call
      Aws::S3::Resource.new
        .then { |r| r.bucket(BUCKET) }
        .then { |b| b.object(object_key) }
        .then { |o| upload(o); o }
        .then { |o| o.public_url }
    end

    private

    def upload(object)
      log("uploading archive from #{archive_path}")
      File.open(archive_path, 'rb') do |file|
        object.put(acl: 'public-read', body: file)
      end
      log("upload complete")
    end

    def object_key
      @object_key ||= ENV['AWS_BUCKET_KEY_PREFIX'] + '/' + File.basename(archive_path)
    end

    def log(msg)
      logger.info(format_log(msg))
    end

    def format_log(msg)
      "#{self.class.name} : #{msg}"
    end
  end
end
