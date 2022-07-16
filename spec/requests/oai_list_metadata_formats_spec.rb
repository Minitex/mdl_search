require 'rails_helper'

describe 'OAI ListMetadataFormats verb' do
  before do
    solr_fixtures('otter:297')
    get '/catalog/oai?verb=ListMetadataFormats'
  end

  it_behaves_like 'OAI responses', verb: 'ListMetadataFormats'

  it 'has the Dublin Core format' do
    parsed = Nokogiri::XML(response.body)

    metadata_formats = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListMetadataFormats/xmlns:metadataFormat')
    expect(metadata_formats.size).to eq 1
    expect(metadata_formats.xpath('//xmlns:metadataPrefix').map(&:text)).to eq ['oai_dc']
  end
end
