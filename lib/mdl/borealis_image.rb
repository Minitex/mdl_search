require_relative './thumbnail'

module MDL
  class BorealisImage < BorealisAsset
    def src
      "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/full/full/0/default.jpg"
    end

    def type
      'image'
    end

    def thumbnail
      Thumbnail.new(
        id: id,
        collection: collection,
        cache_dir: '' # Don't need cache for this use case
      ).thumbnail_url
    end

    def downloads
      [
        { src: "https://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/150,/0/default.jpg", label: '(150w)' },
        { src: "https://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/800,/0/default.jpg", label: '(800w)' }
      ]
    end
  end
end
