require 'cdmbl'
require 'mdl/transformer'
require 'mdl/job_auditing'

module MDL
  ###
  # This FieldTransformer subclass exists to aggregate fields of
  # "child" compounds to an indexed, multivalued field on the parent
  # so that searches for content that exists in child documents return
  # results that contain the parent document.
  class CompoundAggregatingFieldTransformer < CDMBL::FieldTransformer
    TRANSC_FIELD_MAPPING = MDL::Transformer.field_mappings.find do |m|
      m[:dest_path] == 'transcription_tesi'
    end
    RESOUR_FIELD_MAPPING = MDL::Transformer.field_mappings.find do |m|
      m[:dest_path] == 'identifier_ssi'
    end

    attr_reader :record

    def initialize(record:, **args)
      @record = record
      super
    end

    def reduce
      super.tap do |hsh|
        hsh.merge!(aggregations)
      end
    end

    private

    def aggregations
      {}.tap do |hsh|
        ###
        # To aggregate more child fields, merge them in here.
        #   ex.
        # hsh.merge!(child_field_1)
        # hsh.merge!(child_field_2)
        # hsh.merge!(child_field_3)
        hsh.merge!(transcriptions)
        hsh.merge!(mdl_identifiers)
      end.select { |_, v| v.present? }
    end

    def transcriptions
      transcription_pages = Array(record['page']).select { |p| p['transc'] }
      transcriptions = transcription_pages.flat_map do |page|
        self.class.superclass.new(
          record: page,
          field_mapping: CDMBL::FieldMapping.new(config: TRANSC_FIELD_MAPPING)
        ).reduce.values
      end
      { 'transcription_tesim' => transcriptions }
    end

    def mdl_identifiers
      identifiers = Array(record['page'])
        .select { |p| p['resour'] }
        .flat_map do |page|
          self.class.superclass.new(
            record: page,
            field_mapping: CDMBL::FieldMapping.new(config: RESOUR_FIELD_MAPPING)
          ).reduce.values
        end

      { 'identifier_ssim' => identifiers }
    end
  end

  class RecordTransformer < CDMBL::RecordTransformer
    def field_transformer
      CompoundAggregatingFieldTransformer
    end
  end

  class CompoundAggregatingTransformer < CDMBL::Transformer
    def record_transformer
      RecordTransformer
    end
  end

  class TransformWorker < CDMBL::TransformWorker
    prepend EtlAuditing

    def transformer_klass
      @transformer_klass ||= CompoundAggregatingTransformer
    end
  end

  class OaiRequest < CDMBL::OaiRequest
    def initialize(**kwargs)
      super(kwargs.merge(client: OAIClient))
    end
  end

  class OAIClient
    class << self
      ###
      # Shim a read_timeout into a duck-typed HTTP client that
      # implements the interface expected by CDMBL::OaiRequest
      # (uses Net::HTTP by default). By injecting this, we can
      # handle the monstrous timeout required by CONTENTdm's
      # OAI endpoint.
      def get_response(uri)
        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == 'https',
          read_timeout: 180 # CONTENTdm's OAI endpoint can be SLOW
        ) do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request)
        end
      end
    end
  end

  class Extractor < CDMBL::Extractor
    def initialize(**kwargs)
      super(kwargs.merge(oai_request_klass: OaiRequest))
    end
  end

  class ETLWorker < CDMBL::ETLWorker
    prepend EtlAuditing

    def initialize
      @transform_worker_klass = TransformWorker
      @extractor_klass = Extractor
      @etl_worker_klass = self.class
    end
  end
end
