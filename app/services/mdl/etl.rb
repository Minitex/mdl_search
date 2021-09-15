module MDL
  class ETL
    attr_reader :oai_endpoint,
                :set_spec_pattern,
                :field_mappings,
                :filter_callback,
                :set_spec_filter
    def initialize(oai_endpoint: 'https://cdm16022.contentdm.oclc.org/oai/oai.php',
                  set_spec_pattern: /^ul_([a-zA-Z0-9])*\s-\s/,
                  field_mappings:  Transformer.field_mappings,
                  filter_callback: CDMBL::RegexFilterCallback,
                  set_spec_filter: CDMBL::FilteredSetSpecs)
      @oai_endpoint     = oai_endpoint
      @set_spec_pattern = set_spec_pattern
      @field_mappings   = field_mappings
      @filter_callback  = filter_callback
      @set_spec_filter  = set_spec_filter
    end

    def run(set_specs: [], from: nil)
      IndexingRun.create!
      msg_which = set_specs.size > 1 ? "#{set_specs.size} collections" : set_specs.first
      msg_from = from ? "from #{from}" : ''
      message = "ETL Started for #{msg_which} #{msg_from}".rstrip
      Raven.send_event(Raven::Event.new(message: message))
      CDMBL::ETLBySetSpecs.new(
        set_specs: set_specs,
        etl_config: config.tap { |c| c.merge!(from: from) if from },
        etl_worker_klass: MDL::ETLWorker
      ).run!
    end

    def config
      {
        oai_endpoint: oai_endpoint,
        extract_compounds: false,
        field_mappings: field_mappings,
        cdm_endpoint: 'https://server16022.contentdm.oclc.org/dmwebservices/index.php',
        max_compounds: 1,
        batch_size: 5,
        solr_config: solr_config
      }.tap do |hsh|
        hsh[:from] = 8.days.ago.to_date.iso8601 unless ENV['INGEST_ALL']
      end
    end

    def set_specs
      @set_specs ||= filtered_set_specs
    end

    private

    def filter
      filter_callback.new(field: 'setName',
                          pattern: set_spec_pattern,
                          inclusive: false)
    end

    def filtered_set_specs
      set_spec_filter.new(oai_base_url: oai_endpoint,
                          callback: filter).set_specs
    end

    def solr_config
      { url: Blacklight.default_index.connection.options[:url] }
    end
  end
end
