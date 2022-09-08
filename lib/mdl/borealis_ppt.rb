module MDL
  class BorealisPpt <  BorealisAsset
    def src
      "http://cdm16022.contentdm.oclc.org/utils/getfile/collection/#{collection}/id/#{id}/filename"
    end

    def downloads
      []
    end

    def type
      'ppt'
    end

    def viewer
      MDL::BorealisPptViewer
    end
  end
end
