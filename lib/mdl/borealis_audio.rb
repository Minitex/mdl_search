module MDL
  class BorealisAudio < BorealisAsset
    def src
      "http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/#{audio_id}/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4"
    end

    def downloads
      []
    end

    def viewer
      MDL::BorealisAudioPlayer
    end

    def type
      (audio_playlist_id) ? 'kaltura_audio_playlist' : 'kaltura_audio'
    end

    def audio_playlist_id
      document.fetch('kaltura_audio_playlist_ssi', false)
    end

    def audio_id
      document.fetch('kaltura_audio_ssi', false)
    end
  end
end
