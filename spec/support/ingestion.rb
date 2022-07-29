module Ingestion
  class SolrFixture
    attr_reader :id, :path

    def initialize(id)
      @id = id
      @path = Rails.root.join('spec', 'fixtures', 'ingestion', "#{id}.yml")
    end

    def data
      YAML.load_file(path)
    end
  end

  def solr_fixtures(*ids)
    client = SolrClient.new.client
    records = ids.map { |id| SolrFixture.new(id).data }
    client.add(records)
    client.commit
  end
end

RSpec.configure do |c|
  [:request, :feature].each do |type|
    c.include Ingestion, type: type

    c.before(:each, type: type) do
      SolrClient.new.delete_index
    end
  end
end
