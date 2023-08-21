module MDL
  class Thumbnail
    DEFAULT_AUDIO_URL = '/images/audio-3.png'.freeze
    DEFAULT_VIDEO_URL = '/images/video-1.png'.freeze
    DEFAULT_PDF_URL = '/images/reflections-pdf-icon.png'.freeze

    attr_accessor :collection, :id, :title, :type

    def initialize(collection: :missing_collection,
                   id: :missing_id,
                   title: '',
                   type: '')
      @collection = collection
      @id         = id
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

    alias_method :url, :thumbnail_url

    private

    def remote_url
      "https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/#{collection}/id/#{id}"
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
  end
end
