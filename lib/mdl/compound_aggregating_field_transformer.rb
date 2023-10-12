module MDL
  ###
  # This FieldTransformer subclass exists to aggregate fields of
  # "child" compounds to an indexed, multivalued field on the parent
  # so that searches for content that exists in child documents return
  # results that contain the parent document.
  class CompoundAggregatingFieldTransformer < CDMBL::FieldTransformer
    TRANSC_FIELD_MAPPING = Transformer.field_mappings.find do |m|
      m[:dest_path] == 'transcription_tesi'
    end
    RESOUR_FIELD_MAPPING = Transformer.field_mappings.find do |m|
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
end
