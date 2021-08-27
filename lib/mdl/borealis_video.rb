module MDL
  class BorealisVideo < BorealisAsset
    def src(entry_id = nil)
      entry_id ||= (playlist_id || video_id)
      "http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/#{entry_id}/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4"
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

    def playlist_data
      data = document.fetch('kaltura_video_playlist_entry_data_ts', '[]')
      JSON.parse(data)
    end

    def playlist?
      type == 'kaltura_video_playlist'
    end

    def viewer
      MDL::BorealisVideoPlayer
    end
  end
end
