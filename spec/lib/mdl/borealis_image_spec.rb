require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_image.rb'
require_relative '../../../lib/mdl/borealis_open_seadragon.rb'
module MDL
  describe BorealisImage do
    let(:image) do
      MDL::BorealisImage.new collection: 'foo', id: 21
    end

    it 'correctly identifies its src' do
      expect(image.src).to eq '/contentdm-images/info?id=foo:21'
    end

    it 'correctly identifies its type' do
      expect(image.type).to eq 'image'
    end

    it 'correctly identifies its downloads' do
      expect(image.downloads).to eq [
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/foo/21/full/150,/0/default.jpg", label: '(150w)' },
        { src: "http://cdm16022.contentdm.oclc.org/digital/iiif/foo/21/full/800,/0/default.jpg", label: '(800w)' }
      ]
    end

    it 'knows its player' do
      expect(image.viewer).to be MDL::BorealisOpenSeadragon
    end
  end
end

