class IiifSearchAutocompleteService
  class SearchClient
    def initialize
      @solr = RSolr.connect(url: IIIF_SEARCH_SOLR_URL)
    end

    def search(query:, item_id:)
      @solr.get('select', params: {
        start: 0,
        rows: 100,
        qt: 'search',
        fq: "item_id:\"#{item_id}\"",
        fl: 'id',
        q: q(query),
        defType: 'edismax',
        hl: 'on',
        'hl.fl' => 'line',
        'hl.method' => 'unified',
        wt: 'json'
      })
    end

    private

    def q(query)
      if query =~ /^\w+$/ # just one word?
        "line:#{query}*"
      else
        "line:\"#{query}*\""
      end
    end
  end

  class << self
    def call(query:, item_id:)
      solr_response = SearchClient.new.search(
        query: query,
        item_id: item_id
      )

      IiifSearchAutocompleteResponse.new(
        solr_response,
        query: query,
        item_id: item_id
      )
    end
  end
end
