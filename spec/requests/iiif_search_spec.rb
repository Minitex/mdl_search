require 'rails_helper'

describe 'IIIF search', slow: true do
  context 'when image OCR content is indexed' do
    let(:logger) { double('Logger', info: nil, error: nil) }
    let(:identifier) { 'p16022coll60:1157' }

    before do
      VCR.use_cassette('iiif_search') do
        MDL::ProcessDocumentForSearch.new(
          identifier,
          logger: logger
        ).call
      end
    end

    it 'is searchable through the API' do
      get "/iiif/#{identifier}/search?q=universal"
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['resources'].size).to eq(3)
    end
  end
end
