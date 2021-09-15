require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_pdf_viewer.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'
module MDL
  describe BorealisPDFViewer do
    let(:pdf) do
      instance_double(
        'BorealisPDF',
        src: 'http://stuffstuff.com/pdf',
        type: 'pdf',
        text: '(Download)',
        transcripts: ['A brief history of cat costumes'],
        thumbnail: '/images/audio-3.png'
      )
    end

    it 'produces a configuration for PDFs' do
      expect(pdf).to receive(:thumbnail)
      expect(pdf).to receive(:collection)
      expect(pdf).to receive(:src)
      expect(pdf).to receive(:transcripts)
      expect(viewer(pdf)).to be_kind_of(Hash)
      expect(viewer(pdf)['type']).to eq 'pdf'
      expect(viewer(pdf)['config']).to eq('height' => 800, 'width' => '100%')
      expect(viewer(pdf)['transcript']).to eq('texts' => [], 'label' => 'PDF')
      expect(viewer(pdf)['thumbnail']).to eq '/images/reflections-pdf-icon.png'
      expect(viewer(pdf)['values']).to eq(
        [
          {
            'src' => 'http://stuffstuff.com/pdf',
            'thumbnail' => '/images/audio-3.png',
            'transcript' => {
              'texts' => ['A brief history of cat costumes'],
              'label' => 'PDF'
            }
          }
        ]
      )
    end

    def viewer(asset)
      @viewer ||= BorealisPDFViewer.new(assets: [asset]).to_viewer
    end
  end
end
