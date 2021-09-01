module MDL
  class Thumbnail
    DEFAULT_AUDIO_URL = '/images/audio-3.png'.freeze
    DEFAULT_VIDEO_URL = '/images/video-1.png'.freeze

    attr_accessor :collection, :id, :cache_dir, :title, :type

    def initialize(collection: :missing_collection,
                   id: :missing_id,
                   cache_dir: default_cache_dir,
                   title: '',
                   type: '')
      @collection = collection
      @id         = id
      @cache_dir  = cache_dir
      @title      = title
      @type       = type
    end

    def thumbnail_url
      case thumbnail_type
      when :sound
        DEFAULT_AUDIO_URL
      when :video
        DEFAULT_VIDEO_URL
      when :contentdm
        remote_url
      end
    end

    def save
      File.open(file_path, 'wb') { |file| file.write(data) }
    end

    def cached?
      File.exists?(file_path)
    end

    def url
      static? ? local_static_url : local_dynamic_url
    end

    def data
      @data ||= Net::HTTP.get_response(URI(thumbnail_url)).body
    end

    def file_path
      "#{cache_dir}/#{filename}"
    end

    def cached_file
      File.read(file_path)
    end

    def filename
      "#{collection}_#{id}.jpg"
    end

    private

    def static?
      default? || cached?
    end

    def default?
      [:sound, :video].include?(thumbnail_type)
    end

    def remote_url
      "https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/#{collection}/id/#{id}"
    end

    def local_static_url
      default? ? thumbnail_url : file_path.split('public').last
    end

    def local_dynamic_url
      Rails.application.routes.url_helpers.thumbnail_path("#{collection}:#{id}", type)
    end

    def thumbnail_type
      case type
      when 'Sound Recording Nonmusical'
        :sound
      when 'Moving Image'
        :video
      else
        :contentdm
      end
    end

    def default_cache_dir
      File.join(
        Rails.root,
        'public',
        'assets',
        'thumbnails'
      )
    end
  end
end
