require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_image.rb'

module MDL
  describe BorealisImage do
    let(:image) do
      MDL::BorealisImage.new collection: 'foo', id: 21
    end

    it 'has a thumbnail from ContentDM' do
      expect(image.thumbnail).to eq(
        'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/foo/id/21'
      )
    end

    it 'correctly identifies its src' do
      expected_src = 'https://cdm16022.contentdm.oclc.org/iiif/2/foo:21/full/full/0/default.jpg'
      expect(image.src).to eq expected_src
    end

    it 'correctly identifies its type' do
      expect(image.type).to eq 'image'
    end

    it 'correctly identifies its downloads' do
      expect(image.downloads).to eq [
        { src: 'https://cdm16022.contentdm.oclc.org/digital/iiif/foo/21/full/150,/0/default.jpg', label: '(150w)' },
        { src: 'https://cdm16022.contentdm.oclc.org/digital/iiif/foo/21/full/800,/0/default.jpg', label: '(800w)' }
      ]
    end
  end
end

