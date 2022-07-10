require 'rails_helper'

describe 'search' do
  before do
    solr_fixtures('sll:22470', 'msn:2277', 'msn:2670', 'otter:297')
  end

  context 'search_field=all_fields' do
    it 'searches all fields' do
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
      expect(results).to all satisfy { |r|
        r.contributor == 'Minnesota Streetcar Museum'
      }
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

  context 'search_field=title' do
    it 'searches title' do
      get '/catalog?search_fields=title&q=Phalen%20Park'
      expect(response).to have_http_status(:ok)
      expect(results.size).to eq(1)
      expect(results[0].title).to eq(<<~TITLE.strip)
        Streetcar in Phalen Park, St. Paul, Minnesota
      TITLE
    end
  end

  context 'search_field=creator' do
    it 'searches creator' do
      get '/catalog?search_fields=creator&q=podas'
      expect(results.size).to eq(1)
      expect(results[0].creator).to eq('Podas, Norm')
    end
  end

  context 'search_field=subject' do
    it 'searches by subject' do
      get '/catalog?search_field=subject&q=housing'
      expect(results.size).to eq(1)
      expect(results[0].title).to start_with('A. Aberle residence')
    end
  end

  context 'search_field=description' do
    it 'searches description' do
      get '/catalog?search_field=description&q=August%2016%2C%201990'
      expect(results.size).to eq(1)
      expect(results[0].description).to include('August 16, 1990')
    end
  end

  context 'search_field=city_or_township' do
    it 'searches by city' do
      get '/catalog?search_field=city_or_township&q=St.%20Paul'
      expect(results.size).to eq(2)
      expect(results[0].title).to start_with('Streetcar in Phalen Park')
      expect(results[1].title).to start_with('Interview with Glenn Kelley')
    end
  end

  context 'search_field=county' do
    it 'searches by county' do
      get '/catalog?search_field=county&q=Hennepin'
      expect(results.size).to eq(1)
      expect(results[0].title).to eq(<<~TITLE.strip)
        Streetcar at Mahtomedi wye, Mahtomedi, Minnesota
      TITLE
    end
  end
end
