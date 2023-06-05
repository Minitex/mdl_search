require_relative './download'

module MDL
  class DownloadAsset
    class << self
      ###
      # @param canvas [Hash] IIIF Canvas
      # @return [MDL::DownloadAsset]
      def from_iiif_canvas(canvas)
        image = canvas['images'].first

        new(
          label: canvas['label'],
          url: image.dig('resource', '@id')
        )
      end
    end

    FULL_PATH = %r{/full/full}.freeze

    attr_reader :download, :label, :thumbnail

    def initialize(label:, url:)
      @label = label
      @thumbnail = generate_thumbnail(url)
      @download = generate_download(url, label)
    end

    private

    def generate_thumbnail(url)
      scaled_image_url(url, '90')
    end

    def generate_download(url, label)
      Download.new(scaled_image_url(url, '800'), label)
    end

    def scaled_image_url(url, width)
      url.sub(FULL_PATH, "/full/#{width},")
    end
  end
end
