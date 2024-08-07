require_relative '../../../lib/mdl/borealis_asset.rb'

module MDL
  describe BorealisAsset do
    it 'responds to its api' do
      asset =  BorealisAsset.new(id: '', collection: '')
      expect(asset).to respond_to(:id, :collection)
    end

    it 'correctly identifies its type' do
      asset =  BorealisAsset.new
      expect(asset.type).to eq :missing_type
    end

    it 'derives a thumbnail link' do
      asset =  BorealisAsset.new(id: '1', collection: 'foo')
      expect(asset.thumbnail).to eq(
        'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/foo/id/1'
      )
    end
  end
end
