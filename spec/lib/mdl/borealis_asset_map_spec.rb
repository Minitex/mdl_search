require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_asset_map.rb'
require_relative '../../../lib/mdl/borealis_image.rb'
require_relative '../../../lib/mdl/borealis_audio.rb'
require_relative '../../../lib/mdl/borealis_video.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'
require_relative '../../../lib/mdl/borealis_ppt.rb'
module MDL
  describe BorealisAssetMap do
    it 'default maps to the image viewer' do
      expect(MDL::BorealisAssetMap.new.map).to be BorealisImage
      expect(MDL::BorealisAssetMap.new(format_field: nil).map).to be BorealisImage
    end

    it 'correctly maps images' do
      expect(MDL::BorealisAssetMap.new(format_field: 'image/jp2').map).to be BorealisImage
      expect(MDL::BorealisAssetMap.new(format_field: 'image/jp2;').map).to be BorealisImage
      expect(MDL::BorealisAssetMap.new(format_field: 'tif').map).to be BorealisImage
      expect(MDL::BorealisAssetMap.new(format_field: 'jp2').map).to be BorealisImage
      expect(MDL::BorealisAssetMap.new(format_field: 'jpg').map).to be BorealisImage
    end

    it 'correctly maps video' do
      expect(MDL::BorealisAssetMap.new(format_field: 'mp4').map).to be BorealisVideo
      expect(MDL::BorealisAssetMap.new(format_field: 'video/mp4').map).to be BorealisVideo
      expect(MDL::BorealisAssetMap.new(format_field: 'video/DV').map).to be BorealisVideo
      expect(MDL::BorealisAssetMap.new(format_field: 'video/dv video/mp4').map).to be BorealisVideo
    end

    it 'correctly maps pdf' do
      expect(MDL::BorealisAssetMap.new(format_field: 'pdf').map).to be BorealisPdf
      expect(MDL::BorealisAssetMap.new(format_field: 'pdfpage').map).to be BorealisPdf
      expect(MDL::BorealisAssetMap.new(format_field: 'application/pdf').map).to be BorealisPdf
    end

    it 'correctly maps audio' do
      expect(MDL::BorealisAssetMap.new(format_field: 'mp3').map).to be BorealisAudio
    end

    it 'correctly maps ppt' do
      expect(MDL::BorealisAssetMap.new(format_field: 'pptx').map).to be BorealisPpt
    end
  end
end
