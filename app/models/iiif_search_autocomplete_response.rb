class IiifSearchAutocompleteResponse
  HIGHLIGHT = /<em>(.*?)<\/em>/.freeze
  CONTEXT = 'http://iiif.io/api/search/1/context.json'.freeze

  attr_reader :solr_response, :item_id, :query

  def initialize(solr_response, query:, item_id:)
    @solr_response = solr_response
    @item_id = item_id
    @query = query
  end

  def as_json(*)
    {
      '@context' => CONTEXT,
      '@id' => id,
      '@type' => 'search:TermList',
      'terms' => terms
    }
  end

  private

  def terms
    highlighting.values.group_by do |h|
      h['line'].first.scan(HIGHLIGHT).flatten.join(' ').downcase
    end.map do |match, group|
      {
        'match' => match,
        'url' => search_url(match),
        'count' => group.size
      }
    end
  end

  def highlighting
    solr_response['highlighting']
  end

  def id
    URI.escape(
      "https://collection.mndigital.org/iiif/#{item_id}/autocomplete?q=#{query}"
    )
  end

  def search_url(match)
    URI.escape(
      "https://collection.mndigital.org/iiif/#{item_id}/search?q=#{match}"
    )
  end
end
