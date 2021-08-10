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

    def manifest_url
      "/iiif/#{document['id']}/manifest.json"
    end

    def to_manifest_json
      hours, minutes, seconds = document
        .fetch('dimensions_ssi', '04:00:00') # 4 hour default, UV needs a value
        .split(':')
        .map(&:to_i)
      minutes += hours * 60
      seconds += minutes * 60
      JSON.generate({
        '@context' => "http://iiif.io/api/presentation/3/context.json",
        id: "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/manifest.json",
        type: "Manifest",
        label: {
          en: [title]
        },
        items: [
          {
            id: "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/canvas",
            type: "Canvas",
            duration: seconds,
            items: [
              {
                id: "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/canvas/page",
                type: "AnnotationPage",
                items: [
                  {
                    id: "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/canvas/page/annotation",
                    type: "Annotation",
                    motivation: "painting",
                    body: {
                      id: src,
                      type: "Sound",
                      duration: seconds,
                      format: "audio/mp4"
                    },
                    target: "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/canvas"
                  }
                ]
              }
            ]
          }
        ]
      })
    end
  end
end
