require_relative '../../../lib/mdl/borealis_asset_map.rb'

module MDL
  describe BorealisAssetMap do
    it 'default maps to the image viewer' do
      expect(MDL::BorealisAssetMap[nil]).to be BorealisImage
    end

    it 'correctly maps images' do
      expect(MDL::BorealisAssetMap['image/jp2']).to be BorealisImage
      expect(MDL::BorealisAssetMap['image/jp2;']).to be BorealisImage
      expect(MDL::BorealisAssetMap['tif']).to be BorealisImage
      expect(MDL::BorealisAssetMap['jp2']).to be BorealisImage
      expect(MDL::BorealisAssetMap['jpg']).to be BorealisImage
    end

    it 'correctly maps video' do
      expect(MDL::BorealisAssetMap['mp4']).to be BorealisVideo
      expect(MDL::BorealisAssetMap['video/mp4']).to be BorealisVideo
      expect(MDL::BorealisAssetMap['video/DV']).to be BorealisVideo
      expect(MDL::BorealisAssetMap['video/dv video/mp4']).to be BorealisVideo
    end

    it 'correctly maps pdf' do
      expect(MDL::BorealisAssetMap['pdf']).to be BorealisPdf
      expect(MDL::BorealisAssetMap['pdfpage']).to be BorealisPdf
      expect(MDL::BorealisAssetMap['application/pdf']).to be BorealisPdf
    end

    it 'correctly maps audio' do
      expect(MDL::BorealisAssetMap['mp3']).to be BorealisAudio
    end

    it 'correctly maps ppt' do
      expect(MDL::BorealisAssetMap['pptx']).to be BorealisPpt
    end
  end
end
