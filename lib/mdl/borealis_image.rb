require_relative './borealis_asset'
require_relative './download'

module MDL
  class BorealisImage < BorealisAsset
    def src
      "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/full/full/0/default.jpg"
    end

    def type
      'image'
    end

    ###
    # @deprecated - use MDL::DownloadAsset instead
    # For images, we now use the IIIF manifest to generate
    # download thumbnails/URLs
    def download
      Download.new(
        "https://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/800,/0/default.jpg",
        '(800w)'
      )
    end
  end
end
