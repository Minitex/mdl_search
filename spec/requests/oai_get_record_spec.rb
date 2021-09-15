require 'rails_helper'

describe 'OAI GetRecord verb' do
  before do
    VCR.use_cassette('ingest_otter:297') do
      Ingestion.ingest_record('otter:297')
    end
    get '/catalog/oai?verb=GetRecord&identifier=oai:reflections.mndigital.org:otter:297&metadataPrefix=oai_dc'
  end

  it_behaves_like 'OAI responses', verb: 'GetRecord'

  it 'has the expected metadata' do
    parsed = Nokogiri::XML(response.body)
    ns = parsed.collect_namespaces
    metadata = parsed.xpath('//xmlns:OAI-PMH/xmlns:GetRecord/xmlns:record/xmlns:metadata')

    expect(metadata.xpath('//oai_dc:dc/dc:date', ns).text).to eq '1895?'
    expect(metadata.xpath('//oai_dc:dc/dc:subject', ns).text).to eq 'Aberle, A.'
    expect(metadata.xpath('//oai_dc:dc/dc:title', ns).text).to eq 'A. Aberle residence, 214 South Peck Street, Fergus Falls, Minnesota'
    expect(metadata.xpath('//oai_dc:dc/dc:format', ns).text).to eq 'Black-and-white photographs'
    expect(metadata.xpath('//oai_dc:dc/dc:type', ns).text).to eq 'Still Image'
    expect(metadata.xpath('//oai_dc:dc/dc:description', ns).text).to eq 'Images includes view of brick house with windmill to right and chicken wire fence in foreground. Mr. Aberle owned the Fergus Falls Brewery.'
    expect(metadata.xpath('//oai_dc:dc/dc:source', ns).text).to eq 'Fergus Printing and Publishing Company (Fergus Falls, Minnesota)'
    expect(metadata.xpath('//oai_dc:dc/dc:relation', ns).text).to eq 'Architecture'
    expect(metadata.xpath('//oai_dc:dc/dc:publisher', ns).text).to eq 'Otter Tail County Historical Society'
    expect(metadata.xpath('//oai_dc:dc/dc:rights', ns).text).to eq 'Copyright © 2005 Otter Tail County Historical Society. Contact contributing institution for reproduction.'
  end
end
