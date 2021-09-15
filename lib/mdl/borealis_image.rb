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
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/150,150/0/default.jpg", label: '(150 x 150)' },
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/#{collection}/#{id}/full/800,800/0/default.jpg", label: '(800 x 800)' }
      ]
    end

    def viewer
      MDL::BorealisOpenSeadragon
    end
  end
end
