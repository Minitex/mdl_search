require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_ppt_viewer.rb'
require_relative '../../../lib/mdl/borealis_ppt.rb'
module MDL
  describe BorealisPPTViewer do
    let(:ppt) do
      instance_double(
        'BorealisPPT',
        collection: 'ppts',
        id: 33,
        type: 'ppt',
        text: '(Download)',
        thumbnail: '/images/audio-3.png'
      )
    end

    it 'produces a configuration for Audios' do
      expect(ppt).to receive(:type)
      expect(ppt).to receive(:thumbnail)
      expect(ppt).to receive(:src)
      expect(viewer(ppt)).to be_kind_of(Hash)
      expect(viewer(ppt)['type']).to eq 'ppt'
      expect(viewer(ppt)['text']).to eq '(Download)'
      expect(viewer(ppt)['transcript']).to eq('texts' => [],
                                              'label' => 'PowerPoint')
      expect(viewer(ppt)['thumbnail']).to eq '/images/audio-3.png'
    end

    def viewer(asset)
      @viewer ||= BorealisPPTViewer.new(assets: [asset]).to_viewer
    end
  end
end
