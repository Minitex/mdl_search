module MDL
  class DownloadAsset
    FULL_PATH = %r{/full/full}.freeze

    class << self
      ###
      # @param manifest [Hash] Parsed IIIF Manifest v2
      # @return [Array<MDL::DownloadAsset>]
      def assets_from_manifest_v2(manifest)
        Array(manifest.dig('sequences', 0, 'canvases'))
          .map do |canvas|
            url = canvas.dig('images', 0, 'resource', '@id')
            label = canvas['label']
            new(
              label: label,
              thumbnail: generate_thumbnail(url),
              download: generate_download(url, label)
            )
          end
      end

      ###
      # @param manifest [Hash] Parsed IIIF Manifest v3
      # @return [Array<MDL::DownloadAsset>]
      def assets_from_manifest_v3(manifest)
        Array(manifest.dig('rendering')).filter_map do |r|
          next if r['format'] == 'text/vtt'

          label = r.dig('label', 'en', 0)
          thumbnail = r.dig('thumbnail', 0, 'id')
          thumbnail ||= thumbnail = case r['type']
          when 'Video' then Thumbnail::DEFAULT_VIDEO_URL
          when 'Sound' then Thumbnail::DEFAULT_AUDIO_URL
          when 'Text' then Thumbnail::DEFAULT_PDF_URL
          end
          new(
            label: label,
            download: Download.new(r['id'], label),
            thumbnail: thumbnail
          )
        end
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

    attr_reader :download, :label, :thumbnail

    def initialize(label:, thumbnail:, download:)
      @label = label
      @thumbnail = thumbnail
      @download = download
    end
  end
end
