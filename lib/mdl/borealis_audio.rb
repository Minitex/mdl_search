module MDL
  class BorealisAudio < BorealisAsset
    def src(entry_id = audio_id)
      "http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/#{entry_id}/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4"
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

    def playlist_data
      data = document.fetch('kaltura_audio_playlist_entry_data_ts', '[]')
      JSON.parse(data)
    end

    def playlist?
      type == 'kaltura_audio_playlist'
    end
  end
end
