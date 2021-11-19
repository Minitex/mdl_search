namespace :backfill do
  desc 'Backfill IIIF manifest service description for documents searchable in UniversalViewer'
  task iiif_manifest_service_autocomplete: :environment do
    client = SolrClient.new.client
    response = client.get('select', params: {
      qt: 'search',
      q: '*:*',
      defType: 'edismax',
      'facet.query' => 'type_ssi:Text',
      'facet.limit' => 250,
      'facet.pivot' => 'setspec_ssi'
    })
    setspecs = response.dig(
      'facet_counts',
      'facet_pivot',
      'setspec_ssi'
    )
    puts "Queueing #{setspecs.count} setspecs for backfill"
    setspecs.each do |setspec|
      collection = setspec['value']
      UpdateIiifManifestServiceDescriptionWorker.perform_async(collection)
    end
  end
end
