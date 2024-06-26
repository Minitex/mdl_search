require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_ppt.rb'

module MDL
  describe BorealisPpt do
    it 'provides downloads' do
      expect(BorealisPpt.new.downloads).to eq []
    end

    it 'knows its type' do
      expect(BorealisPpt.new.type).to eq 'ppt'
    end

    it 'knows its src' do
      expect(BorealisPpt.new(collection: 'foo',
                             id: '123').src).to eq 'http://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/123/filename'
    end
  end
end
