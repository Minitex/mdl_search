module MDL
  class CompoundAggregatingTransformer < CDMBL::Transformer
    def record_transformer
      RecordTransformer
    end
  end
end
