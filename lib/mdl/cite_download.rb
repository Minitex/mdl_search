module MDL
  class CiteDownload
    attr_reader :assets

    def initialize(assets: [])
      @assets = assets
    end

    def to_hash
      {
        focus: false,
        type: 'download',
        label: 'Download',
        fields: downloads
      }
    end

    def downloads
      assets.filter_map do |asset|
        {
          thumbnail: asset.thumbnail,
          label: asset.download.label || '',
          src: asset.download.src
        }
      end
    end
  end
end
