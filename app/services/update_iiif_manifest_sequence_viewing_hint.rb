class UpdateIiifManifestSequenceViewingHint
  class << self
    def for_collection(setspec)
      start = 0
      rows = 20
      response = next_batch(setspec, start: start, rows: rows)
      while response['response']['numFound'] > start
        process_batch(response['response']['docs'])
        start += rows
        response = next_batch(setspec, start: start, rows: rows)
      end
      solr_client.commit
    end

    private

    def next_batch(setspec, start:, rows:)
      solr_client.get('select', params: {
        q: '*:*',
        defType: 'edismax',
        fl: '*',
        fq: "type_ssi:Text AND setspec_ssi:#{setspec}",
        start: start,
        rows: rows
      })
    end

    def process_batch(docs)
      updated_docs = docs.map { |d| update_document(d) }
      solr_client.add(updated_docs)
    end

    def update_document(doc)
      manifest = JSON.parse(doc['iiif_manifest_ss'])
      MDL::IiifManifestFormatter.format_sequence(manifest)
      doc['iiif_manifest_ss'] = manifest.to_json
      doc
    end

    def solr_client
      Blacklight.default_index.connection
    end
  end
end
