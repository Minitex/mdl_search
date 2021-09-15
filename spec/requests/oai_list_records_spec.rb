require 'rails_helper'

describe 'OAI ListRecords verb' do
  before do
    %w(msn:2680 msn:2277 msn:2670 otter:297).each do |id|
      VCR.use_cassette("ingest_#{id}") do
        Ingestion.ingest_record(id)
      end
    end
  end

  context 'a basic request' do
    before do
      get '/catalog/oai?verb=ListRecords&metadataPrefix=oai_dc'
    end

    it_behaves_like 'OAI responses', verb: 'ListRecords'

    it 'has the expected content' do
      parsed = Nokogiri::XML(response.body)

      records = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListRecords/xmlns:record')
      expect(records.size).to eq 4
      expect(records.xpath('//xmlns:header/xmlns:identifier').map(&:text)).to eq [
        'oai:reflections.mndigital.org:msn:2680',
        'oai:reflections.mndigital.org:msn:2277',
        'oai:reflections.mndigital.org:msn:2670',
        'oai:reflections.mndigital.org:otter:297'
      ]
    end
  end

  context 'filtered by set' do
    before do
      get '/catalog/oai?verb=ListRecords&metadataPrefix=oai_dc&set=msn'
    end

    it_behaves_like 'OAI responses', verb: 'ListRecords'

    it 'has the expected content' do
      parsed = Nokogiri::XML(response.body)

      records = parsed.xpath('//xmlns:OAI-PMH/xmlns:ListRecords/xmlns:record')
      expect(records.size).to eq 3
      expect(records.xpath('//xmlns:header/xmlns:identifier').map(&:text)).to eq [
        'oai:reflections.mndigital.org:msn:2680',
        'oai:reflections.mndigital.org:msn:2277',
        'oai:reflections.mndigital.org:msn:2670'
      ]
    end
  end
end
