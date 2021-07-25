namespace :mdl_ingester do
  desc "ingest batches of records"
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
    Raven.send_event(Raven::Event.new(message: 'Batch delete job started'))
    CDMBL::BatchDeleterWorker.perform_async(
      0,
      50,
      'oai:cdm16022.contentdm.oclc.org:',
      config[:oai_endpoint],
      config[:solr_config][:url]
    )
  end

  def run_etl!(set_specs = [])
    puts "Indexing Sets: '#{set_specs.join(', ')}'"
    IndexingRun.create!
    Raven.send_event(Raven::Event.new(message: 'ETL Started'))
    CDMBL::ETLBySetSpecs.new(
      set_specs: set_specs,
      etl_config: config,
      etl_worker_klass: MDL::ETLWorker
    ).run!
  end

  desc 'Launch a background job to index a single record.'
  task :record, [:id] => :environment  do |t, args|
    MDL::TransformWorker.perform_async(
      [args[:id].split(':')],
      { url: config[:solr_config][:url]},
      config[:cdm_endpoint],
      config[:oai_endpoint],
      config[:field_mappings],
      false
    )
  end

  def config
    etl.config
  end

  def etl
    @etl ||= MDL::ETL.new
  end
end
