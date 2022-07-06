require 'rails_helper'

describe 'search' do
  context 'basic search' do
    before do
      solr_fixtures('sll:22470', 'msn:2277', 'msn:2670', 'otter:297')
    end

    it 'supports an "all_fields" search' do
      get '/catalog?q=library&search_field=all_fields'
      expect(response).to have_http_status(:ok)
      expect(results.size).to eq(1)
      result = results.first
      expect(result.title).to include('Interview with Glenn Kelley')
      expect(result.description).to start_with(<<~DESC.strip)
        Interview with former Minnesota Supreme Court Justice Glenn E. Kelley
      DESC
      expect(result.contributor).to eq('Minnesota State Law Library')
      expect(result.type).to eq('Moving Image')
      expect(result.format).to eq('Oral histories')
    end

    it 'searches contributing organization' do
      get '/catalog?search_fields=all_fields&q=Minnesota%20Streetcar%20Museum'
      expect(response).to have_http_status(:ok)
      expect(results.size).to eq(2)
      expect(results).to all satisfy { |r| r.contributor == 'Minnesota Streetcar Museum' }
    end

    it 'searches title' do
      get '/catalog?search_fields=all_fields&q=Aberle'
      expect(response).to have_http_status(:ok)
      expect(results.size).to eq(1)
      expect(results[0].title).to eq(<<~TITLE.strip)
        A. Aberle residence, 214 South Peck Street, Fergus Falls, Minnesota
      TITLE
    end
  end
end
