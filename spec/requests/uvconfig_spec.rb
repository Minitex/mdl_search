require 'rails_helper'

describe 'UV config requests' do
  let(:headers) do
    { 'Accept' => 'application/json' }
  end

  context 'with an AV playlist' do
    before { solr_fixtures('sll:22470') }

    it 'returns config for left panel closed' do
      get('/uvconfig/sll:22470', headers:)
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      panel_open = parsed_body.dig(
        'modules',
        'contentLeftPanel',
        'options',
        'panelOpen'
      )
      expect(panel_open).to eq(false)
    end
  end

  context 'with a non-playlist' do
    before { solr_fixtures('msn:2277') }

    it 'returns config for left panel open' do
      get('/uvconfig/msn:2277', headers:)
      expect(response).to have_http_status(:ok)
      parsed_body = JSON.parse(response.body)
      panel_open = parsed_body.dig(
        'modules',
        'contentLeftPanel',
        'options',
        'panelOpen'
      )
      expect(panel_open).to eq(true)
    end
  end
end
