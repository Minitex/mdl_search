require 'rails_helper'

describe OaiSet do
  OaiSet.fields = [
    { solr_field: 'oai_set_ssi' }
  ]

  let(:set) do
    OaiSet.new('oai_set_ssi:specId||collectionName||This is the collection description. Usually lengthy, but not in this case.')
  end

  describe '#name' do
    it 'returns the name of the collection' do
      expect(set.name).to eq 'collectionName'
    end
  end

  describe '#spec' do
    it 'returns the spec ID' do
      expect(set.spec).to eq 'specId'
    end
  end

  describe '#description' do
    it 'returns the collection description' do
      expect(set.description).to eq 'This is the collection description. Usually lengthy, but not in this case.'
    end
  end
end
