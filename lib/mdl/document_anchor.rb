module MDL
  class DocumentAnchor
    attr_reader :doc, :search_text, :document_klass, :anchor

    def initialize(doc: {}, search_text: false, document_klass: BorealisDocument)
      @doc = doc
      @search_text = search_text
      @document_klass = document_klass
      @anchor = ''
    end

    def search
      "?searchText=#{search_text}" if search_text
    end
  end
end

deprecator = ActiveSupport::Deprecation.new('soon', 'MDL')
deprecator.deprecate_methods(MDL::DocumentAnchor, anchor: nil)
