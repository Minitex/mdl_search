class UpdateIIIFManifestServiceDescription
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
      updated_docs = docs.map { |d| new(d['id']).update_document(d) }
      solr_client.add(updated_docs)
    end

    def solr_client
      Blacklight.default_index.connection
    end
  end

  attr_reader :id, :solr_client

  def initialize(id, solr_client: default_solr_client)
    @id = id
    @solr_client = solr_client
  end

  def call(doc = fetch_document)
    doc = update_document(doc)
    persist_updates(doc)
  end

  def update_document(doc)
    manifest = JSON.parse(doc['iiif_manifest_ss'])
    manifest['service']['service'] = {
      '@id' => "/iiif/#{id}/autocomplete",
      'profile' => 'http://iiif.io/api/search/1/autocomplete'
    }
    doc['iiif_manifest_ss'] = manifest.to_json
    doc
  end

  def persist_updates(doc)
    solr_client.add(doc)
  end

  private

  def fetch_document
    response = solr_client.get('select', params: {
      qt: 'document',
      ids: id
    })
    raise "No document found for #{id}" unless response['response']['numFound'] > 0
    response['response']['docs'].first
  end

  def default_solr_client
    Blacklight.default_index.connection
  end
end
