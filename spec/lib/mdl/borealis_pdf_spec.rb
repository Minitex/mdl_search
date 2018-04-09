require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'
require_relative '../../../lib/mdl/borealis_pdf_viewer.rb'
module MDL
  describe BorealisPDF do
    describe 'when a pdf is a member of a compound object' do
      it 'provides a download link' do
        expect(BorealisPDF.new(document: { 'id' => 'foo:123' },
                               collection: 'foo', id: '124').downloads).to eq(
          [
            {
              src: 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/124/filename',
              label: 'Download'
            }
          ]
        )
      end
    end

    describe 'when a pdf is a single item' do
      it 'provides a download link' do
        expect(BorealisPDF.new(document: { 'id' => 'foo:123' },
                               collection: 'foo', id: '123').downloads).to eq(
          [
            {
              src: 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/123/filename/123',
              label: 'Download'
            }
          ]
        )
      end
    end

    it 'knows its viewer' do
      expect(BorealisPDF.new.viewer).to be MDL::BorealisPDFViewer
    end

    it 'knows its type' do
      expect(BorealisPDF.new.type).to eq 'pdf'
    end
  end
end
