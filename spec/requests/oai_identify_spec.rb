require 'rails_helper'

describe 'OAI Identify verb' do
  before do
    VCR.use_cassette('ingest_otter:297') do
      Ingestion.ingest_record('otter:297')
    end
    get '/catalog/oai?verb=Identify'
  end

  it_behaves_like 'OAI responses', verb: 'Identify'

  it 'has the expected content' do
    parsed = Nokogiri::XML(response.body)
    ns = parsed.collect_namespaces
    description = parsed.xpath('//xmlns:OAI-PMH/xmlns:Identify/xmlns:description')
    oai_identifier = description.xpath('//xmlns:oai-identifier', ns)

    expect(oai_identifier.xpath('//xmlns:repositoryIdentifier', ns).text).to eq 'reflections.mndigital.org'
    expect(oai_identifier.xpath('//xmlns:sampleIdentifier', ns).text).to eq 'oai:reflections.mndigital.org:sll:22470'
  end
end
