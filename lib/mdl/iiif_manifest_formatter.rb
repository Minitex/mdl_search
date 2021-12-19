module MDL
  class IiifManifestFormatter
    AV_KEYS = %w(audio audioa video videoa)

    class << self
      def format(doc, retries = 3)
        return if av_media?(doc)
        collection, id = doc['id'].split('/')

        url = "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/manifest.json"
        res = Net::HTTP.get_response(URI(url))
        self.format(doc, retries - 1) if res.code != '200' && retries.positive?

        parsed_response = JSON.parse(res.body)
        parsed_response['service'] = {
          '@context' => 'http://iiif.io/api/search/1/context.json',
          '@id' => "/iiif/#{collection}:#{id}/search",
          'profile' => 'http://iiif.io/api/search/1/search',
          'service' => {
            '@id' => "/iiif/#{collection}:#{id}/autocomplete",
            'profile' => 'http://iiif.io/api/search/1/autocomplete'
          }
        }

        format_sequence(parsed_response)
        JSON.generate(parsed_response)
      end

      def format_sequence(manifest)
        sequence = Array(manifest['sequences'])[0]
        canvases = Array(sequence['canvases'])
        if sequence && canvases.size > 2
          ###
          # With this, UV will support "two-up" (side-by-side) pages
          # in the viewer. Only makes sense visually if there are
          # at least three canvases (pages).
          manifest['sequences'][0]['viewingHint'] = 'paged'
        end
      end

      private

      def av_media?(doc)
        AV_KEYS.any? { |k| doc[k].present? }
      end
    end
  end
end
