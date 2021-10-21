class IiifSearchService
  class SearchClient
    def initialize
      @solr = RSolr.connect(url: 'http://localhost:8983/solr/mdl-iiif-search')
    end

    def search(query:, item_id:)
      @solr.get('select', params: {
        start: 0,
        rows: 100,
        qt: 'search',
        fq: "item_id:\"#{item_id}\"",
        fl: 'id,item_id,line,canvas_id,word_boundaries:[json]',
        q: "line:\"#{query}\"",
        defType: 'edismax',
        hl: 'on',
        'hl.fl' => 'line',
        'hl.method' => 'unified',
        wt: 'json'
      })
    end
  end

  class << self
    def call(query:, item_id:)
      ###
      # TODO: can we do something to support phrases that span lines?
      # +query+ could be several words long, and unless all the words
      # are on the same line in the document, we won't have a match.
      # If we expand the search to OR together words or word groups,
      # we potentially effect relevancy in a negative way. We're
      # effectively "stemming" the phrase and shorter stems could end
      # up matching lines that are out of context.
      solr_response = SearchClient.new.search(
        query: query,
        item_id: item_id
      )

      IiifSearchResponse.new(
        solr_response,
        query: query,
        item_id: item_id
      )
    end

    private

    # TODO: delete, probably
    def expanded_query(query)
      words = query.split(' ').map { |w| w.downcase.strip }
      splits = words.map.with_index do |w, i|
        before = words[0..i]
        after = words[(i + 1)..-1]
        [before, after]
      end
      template = '("%s")'
      splits.map do |first, last|
        parts = []
        parts << template % first.join(' ') if first.any?
        parts << template % last.join(' ') if last.any?
        parts.join(' OR ')
      end
    end
  end
end
