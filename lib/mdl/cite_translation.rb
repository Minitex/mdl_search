module MDL
  class CiteTranslation
    attr_reader :solr_doc

    def initialize(solr_doc: {})
      @solr_doc = solr_doc
    end

    ###
    # @return [Hash]
    def to_hash
      return {} if translation.nil?

      {
        focus: false,
        type: 'translation',
        label: 'Translation',
        translation:
      }
    end

    ###
    # @return [String, nil]
    def translation
      @translation ||= begin
        if solr_doc['translation_tesi']
          solr_doc['translation_tesi']
        elsif solr_doc['translation_tesim']
          solr_doc['translation_tesim'].join("\n\n")
        else
          nil
        end
      end
    end
  end
end
