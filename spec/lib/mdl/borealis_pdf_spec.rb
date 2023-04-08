require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'

module MDL
  describe BorealisPdf do
    let(:id) { '123' }
    let(:instance) do
      BorealisPdf.new(
        document: { 'id' => 'foo:123' },
        collection: 'foo',
        id: id
      )
    end

    describe 'when a pdf is a member of a compound object' do
      let(:id) { '124' }
      it 'provides a download link' do
        expect(instance.downloads).to eq([
          {
            src: 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/124/filename',
            label: 'Download PDF'
          }
        ])
      end
    end

    describe 'when a pdf is a single item' do
      it 'provides a download link' do
        expect(instance.downloads).to eq([
          {
            src: 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/123/filename/123',
            label: 'Download PDF'
          }
        ])
      end
    end

    it 'knows its type' do
      expect(BorealisPdf.new.type).to eq 'pdf'
    end
  end
end
