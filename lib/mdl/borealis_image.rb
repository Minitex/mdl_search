module MDL

  class BorealisImage <  BorealisAsset
    def src
      "/contentdm-images/info?id=#{collection}:#{id}"
    end

    def type
      'image'
    end

    def downloads
      [
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/150,/0/default.jpg", label: '(150w)' },
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/800,/0/default.jpg", label: '(800w)' }
      ]
    end

    def viewer
      MDL::BorealisOpenSeadragon
    end
  end
end
