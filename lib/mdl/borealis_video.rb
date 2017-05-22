module MDL
  class BorealisVideo <  BorealisAsset

    def src
      "http://cdm16022.contentdm.oclc.org/utils/getstream/collection/#{collection}/id/#{id}"
    end

    def downloads
        []
    end

    def type
      'kaltura_video'
    end

    def video_id
      document['kaltura_video_ssi']
    end

    def viewer
      MDL::BorealisVideoPlayer
    end

  end
end