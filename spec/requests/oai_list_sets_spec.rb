require 'rails_helper'

describe 'OAI ListSets verb' do
  before do
    solr_fixtures('sll:22470', 'otter:297')

    get '/catalog/oai?verb=ListSets'
  end

  it_behaves_like 'OAI responses', verb: 'ListSets'

  it 'returns the expected format' do
    parsed = Nokogiri::XML(response.body)
    ns = parsed.collect_namespaces

    expect(parsed.xpath('//xmlns:OAI-PMH/xmlns:ListSets/xmlns:set').size).to eq 2
    expect(parsed.xpath('//xmlns:OAI-PMH/xmlns:ListSets/xmlns:set/xmlns:setSpec').map(&:text)).to eq ['otter', 'sll']
    expect(parsed.xpath('//xmlns:OAI-PMH/xmlns:ListSets/xmlns:set/xmlns:setName').map(&:text)).to eq [
      'Otter Tail County Historical Society',
      'Minnesota State Law Library'
    ]
    descriptions = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListSets/xmlns:set/xmlns:setDescription/oai_dc:dc/dc:description', ns).map(&:text)
    expect(descriptions.size).to eq 2
    expect(descriptions).to all satisfy(&:present?)
  end
end
