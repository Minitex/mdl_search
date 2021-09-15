module MDL
  class BorealisVideo < BorealisAsset
    def src
      "http://cdm16022.contentdm.oclc.org/utils/getstream/collection/#{collection}/id/#{id}"
    end

    def downloads
      []
    end

    def type
      (playlist_id) ? 'kaltura_video_playlist' : 'kaltura_video'
    end

    def video_id
      document.fetch('kaltura_video_ssi', false)
    end

    def video_playlist_id
      document.fetch('kaltura_video_playlist_ssi', false)
    end

    def audio_playlist_id
      document.fetch('kaltura_audio_playlist_ssi', false)
    end

    def playlist_id
      video_playlist_id || audio_playlist_id
    end

    def viewer
      MDL::BorealisVideoPlayer
    end
  end
end
