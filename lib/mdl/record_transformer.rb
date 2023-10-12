module MDL
  class RecordTransformer < CDMBL::RecordTransformer
    def field_transformer
      CompoundAggregatingFieldTransformer
    end
  end
end
