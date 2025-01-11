module MDL
  #
  # This formatter fetches the IIIF manifest from CONTENTdm and augments it
  # with page-level metadata (for compound documents), a search service
  # description, and other minor additions. The output JSON is persisted in
  # Solr and served to viewers through the IiifController. Many adjustments to
  # the viewer's presentation require changes to the manifest JSON, and this
  # is the place in the ingestion pipeline to make those changes. Note that A/V
  # documents in particular are excluded from this formatter, since we generate
  # a IIIF manifest on demand for those document types.
  #
  class IiifManifestFormatter
    AV_KEYS = %w(audio audioa video videoa)

    class << self
      def format(doc, retries = 3)
        return if av_media?(doc)
        collection, id = doc['id'].split('/')

        url = "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/manifest.json"
        res = Net::HTTP.get_response(URI(url))
        retries -= 1
        self.format(doc, retries) if res.code != '200' && retries.positive?
        return unless res.code == '200'

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

        apply_page_level_metadata(doc, parsed_response)
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
          sequence['viewingHint'] = 'paged'
        end
      end

      private

      ###
      # For items that will become compound documents (multi-page docs), this
      # will apply page-level metadata to each canvas which will appear in UV
      # in the "More Information" panel on the right side of the viewer.
      def apply_page_level_metadata(doc, manifest)
        canvases = manifest.dig('sequences', 0, 'canvases')
        pages = doc['page']
        return if canvases.nil?
        return if canvases.size != pages.size

        pages.each_with_index do |page, i|
          canvas = canvases[i]
          canvas['metadata'] = build_page_metadata(page)
        end
      end

      # @param page [Hash] a page from a CDM document
      # @return [Array<Hash<String, String>>] array of hashes where
      #   each hash has "label" and "value" keys.
      def build_page_metadata(page)
        [
          { 'label' => 'Title', 'value' => page['title'].presence },
          { 'label' => 'Description', 'value' => page['descri'].presence },
          { 'label' => 'Local Identifier', 'value' => page['identi'].presence },
          { 'label' => 'MDL Identifier', 'value' => page['resour'].presence },
          { 'label' => 'Item Digital Format', 'value' => page['format'].presence },
        ].reject { |h| h['value'].nil? }
      end

      def av_media?(doc)
        AV_KEYS.any? { |k| doc[k].present? }
      end
    end
  end
end
