require 'rails_helper'

describe IiifSearchAutocompleteResponse do
  describe '#as_json' do
    let(:fixture_file) { 'iiif_search_response.json' }
    let(:solr_response) do
      fixture_path = Rails.root.join(
        'spec',
        'fixtures',
        'solr',
        fixture_file
      )
      JSON.parse(IO.read(fixture_path))
    end
    let(:result) do
      IiifSearchAutocompleteResponse.new(
        solr_response,
        query: 'court',
        item_id: 'pch:1224'
      ).as_json
    end

    it 'forms the correct structure' do
      expect(result['@context']).to eq('http://iiif.io/api/search/1/context.json')
      expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/autocomplete?q=court')
      expect(result['@type']).to eq('search:TermList')
      expect(result['terms']).to eq([
        {
          'match' => 'court',
          'url' => 'https://collection.mndigital.org/iiif/pch:1224/search?q=court',
          'count' => 4
        }
      ])
    end

    context 'searching for a multi-word phrase' do
      let(:fixture_file) { 'iiif_search_response_phrase.json' }
      let(:result) do
        IiifSearchAutocompleteResponse.new(
          solr_response,
          query: 'The reasoning of',
          item_id: 'pch:1224'
        ).as_json
      end

      it 'forms the correct structure' do
        expect(result['@context']).to eq('http://iiif.io/api/search/1/context.json')
        expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/autocomplete?q=The%20reasoning%20of')
        expect(result['@type']).to eq('search:TermList')
        expect(result['terms']).to eq([
          {
            'match' => 'the reasoning of',
            'url' => 'https://collection.mndigital.org/iiif/pch:1224/search?q=the%20reasoning%20of',
            'count' => 1
          }
        ])
      end
    end
  end
end
