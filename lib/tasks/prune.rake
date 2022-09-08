namespace :prune do
  desc "Remove Solr records that are no longer in CONTENTdm"
  task all: [:environment] do
    do_prune
  end

  desc "Remove Solr records in the given collection that are no longer in CONTENTdm"
  task :collection, [:set_spec] => :environment do |t, args|
    do_prune(solr_query: "setspec_ssi:#{args[:set_spec]}")
  end

  def do_prune(solr_query: nil)
    Raven.send_event(Raven::Event.new(message: 'Batch delete job started'))
    CDMBL::BatchDeleterWorker.perform_async(
      0,
      50,
      'oai:cdm16022.contentdm.oclc.org:',
      config[:oai_endpoint],
      config[:solr_config][:url],
      solr_query
    )
  end

  def config
    etl.config
  end

  def etl
    @etl ||= MDL::Etl.new
  end
end
