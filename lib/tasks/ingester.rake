namespace :mdl_ingester do
  desc 'Index a single collection'
  task :collection, [:set_spec] => :environment  do |t, args|
    run_etl!([args[:set_spec]])
  end

  desc 'Index A Sample UMedia Collection'
  task collection_sample: [:environment] do
    run_etl!(etl.set_specs.sample(1))
  end

  desc 'Index All MDL Collections'
  task collections: [:environment] do
    run_etl!(etl.set_specs)
  end

  desc "Delete records from Solr that are no longer in CONTENTdm"
  ##
  # e.g. rake mdl_ingester:delete
  task delete: [:environment] do
    puts '[DEPRECATED] please switch to `rake prune:all`'
    Rake::Task['prune:all'].invoke
  end

  def run_etl!(set_specs = [])
    puts "Indexing Sets: '#{set_specs.join(', ')}'"
    args = { set_specs: set_specs }
    args[:from] = 8.days.ago.to_date.iso8601 unless ENV['INGEST_ALL']
    etl.run(**args)
  end

  desc 'Launch a background job to index a single record.'
  task :record, [:id] => :environment do |t, args|
    require Rails.root.join('lib/mdl/etl_worker')
    IndexingRun.create!
    MDL::TransformWorker.perform_async(
      [args[:id].split(':')],
      { 'url' => config[:solr_config][:url]},
      config[:cdm_endpoint],
      config[:oai_endpoint],
      config[:field_mappings].map(&:stringify_keys),
      false
    )
  end

  desc 'Index playlist data for A/V playlist documents'
  task backfill_playlist_data: [:environment] do
    Rake::Task['mdl_ingester:ingest_by_query'].invoke(
      'kaltura_video_ssi:* | kaltura_audio_ssi:*'
    )
  end

  desc 'Index IIIF search data for existing transcriptions'
  task backfill_iiif_search_data: [:environment] do
    Rake::Task['mdl_ingester:ingest_by_query'].invoke('type_ssi:Text')
  end

  desc 'Ingest records returned by the provided Solr query (fq)'
  task :ingest_by_query, [:query] => :environment do |t, args|
    puts "Querying Solr for fq: '#{args[:query]}'"
    client = SolrClient.new
    response = client.connect.get('select', params: {
      defType: 'edismax',
      fq: args[:query],
      qt: 'search',
      rows: 1_000_000,
      q: '*:*',
      wt: 'json'
    })
    count = response['response']['numFound']
    puts "Backfilling #{count} records..."
    IndexingRun.create! unless count.zero?

    response['response']['docs'].each do |doc|
      MDL::TransformWorker.perform_async(
        [doc['id'].split(':')],
        { 'url' => config[:solr_config][:url] },
        config[:cdm_endpoint],
        config[:oai_endpoint],
        config[:field_mappings].map(&:stringify_keys),
        false
      )
    end
  end

  def config
    etl.config
  end

  def etl
    @etl ||= MDL::Etl.new
  end
end
