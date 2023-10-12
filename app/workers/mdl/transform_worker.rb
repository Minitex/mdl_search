module MDL
  class TransformWorker < CDMBL::TransformWorker
    prepend EtlAuditing

    def transformer_klass
      @transformer_klass ||= CompoundAggregatingTransformer
    end
  end
end
