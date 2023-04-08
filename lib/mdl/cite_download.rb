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
        next if asset.downloads.empty?
        {
          thumbnail: asset.thumbnail,
          sources: asset.downloads
        }
      end
    end
  end
end
