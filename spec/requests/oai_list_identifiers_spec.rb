require 'rails_helper'

describe 'OAI ListIdentifiers verb' do
  before do
    %w(msn:2680 msn:2277 msn:2670 otter:297).each do |id|
      VCR.use_cassette("ingest_#{id}") do
        Ingestion.ingest_record(id)
      end
    end
  end

  context 'basic query' do
    before do
      get '/catalog/oai?verb=ListIdentifiers&metadataPrefix=oai_dc'
    end
    it_behaves_like 'OAI responses', verb: 'ListIdentifiers'

    it 'returns the expected records' do
      parsed = Nokogiri::XML(response.body)
      headers = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListIdentifiers/xmlns:header')
      expect(headers.size).to eq 4
      expect(headers.xpath('//xmlns:identifier').map(&:text)).to eq [
        'oai:reflections.mndigital.org:msn:2680',
        'oai:reflections.mndigital.org:msn:2277',
        'oai:reflections.mndigital.org:msn:2670',
        'oai:reflections.mndigital.org:otter:297'
      ]
      expect(headers.xpath('//xmlns:setSpec').map(&:text)).to eq [
        'msn',
        'msn',
        'msn',
        'otter',
      ]
    end
  end

  context 'filtering by set' do
    before do
      get '/catalog/oai?verb=ListIdentifiers&set=otter&metadataPrefix=oai_dc'
    end

    it 'returns the expected records' do
      parsed = Nokogiri::XML(response.body)
      headers = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListIdentifiers/xmlns:header')
      expect(headers.size).to eq 1
      expect(headers.xpath('//xmlns:identifier').map(&:text)).to eq [
        'oai:reflections.mndigital.org:otter:297'
      ]
      expect(headers.xpath('//xmlns:setSpec')).to all satisfy { |e| e.text == 'otter' }
    end
  end
end
