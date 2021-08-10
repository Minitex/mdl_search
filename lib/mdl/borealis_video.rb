module MDL
  class BorealisVideo < BorealisAsset
    def src
      "http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/#{playlist_id || video_id}/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4"
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
            height: 480,
            width: 640,
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
                      type: "Video",
                      height: 480,
                      width: 640,
                      duration: seconds,
                      format: "video/mp4"
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
