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
        expected = Download.new(
          'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/124/filename',
          'Download PDF'
        )
        expect(instance.download).to eq(expected)
      end
    end

    describe 'when a pdf is a single item' do
      it 'provides a download link' do
        expected = Download.new(
          'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/foo/id/123/filename/123',
          'Download PDF'
        )
        expect(instance.download).to eq(expected)
      end
    end

    it 'knows its type' do
      expect(BorealisPdf.new.type).to eq 'pdf'
    end

    describe '#thumbnail_url' do
      it 'returns the expected url' do
        expect(instance.thumbnail_url).to eq(
          'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/foo/id/123'
        )
      end
    end
  end
end
