module Ingestion
  module_function

  def ingest_record(id)
    worker = setup_worker
    worker.perform(
      [id.split(':')],
      { url: config[:solr_config][:url] },
      config[:cdm_endpoint],
      config[:oai_endpoint],
      config[:field_mappings],
      false
    )
    SolrClient.new.commit
  end

  def etl
    @etl ||= MDL::ETL.new
  end

  def config
    @config ||= etl.config
  end

  def setup_worker
    run = IndexingRun.create!
    worker = MDL::TransformWorker.new
    worker.jid = SecureRandom.hex
    run.jobs.create!(
      job_id: worker.jid
    )
    worker
  end
end
