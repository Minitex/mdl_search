namespace :backfill do
  desc 'Backfill IIIF manifest service description for documents searchable in UniversalViewer'
  task iiif_manifest_service_autocomplete: :environment do
    setspecs = fetch_setspecs
    puts "Queueing #{setspecs.count} setspecs for backfill"
    setspecs.each do |setspec|
      collection = setspec['value']
      UpdateIiifManifestServiceDescriptionWorker.perform_async(collection)
    end
  end

  desc 'Backfill IIIF manifest sequence with viewingHint'
  task iiif_manifest_sequence_viewing_hint: :environment do
    setspecs = fetch_setspecs
    puts "Queueing #{setspecs.count} setspecs for backfill"
    setspecs.each do |setspec|
      collection = setspec['value']
      UpdateIiifManifestSequenceViewingHintWorker.perform_async(collection)
    end
  end

  def fetch_setspecs
    client = SolrClient.new.client
    response = client.get('select', params: {
      qt: 'search',
      q: '*:*',
      defType: 'edismax',
      'facet.query' => 'type_ssi:Text',
      'facet.limit' => 250,
      'facet.pivot' => 'setspec_ssi'
    })
    response.dig(
      'facet_counts',
      'facet_pivot',
      'setspec_ssi'
    )
  end
end
