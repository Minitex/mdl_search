require 'rails_helper'

module MDL
  describe BorealisDocument do
    let(:document) do
      { 'id' => 'foo:123', 'format' => 'image/jp2', 'title_ssi' => 'blerg' }
    end

    describe '#manifest_url' do
      subject do
        BorealisDocument.new(document:).manifest_url
      end

      it do
        contentdm_url = 'https://cdm16022.contentdm.oclc.org/iiif/2/foo:123/manifest.json'
        is_expected.to eq(contentdm_url)
      end

      context 'when we have a manifest URL index in Solr' do
        let(:document) do
          super().merge('iiif_manifest_url_ssi' => '/test/manifest.json')
        end

        it { is_expected.to eq('/test/manifest.json') }
      end

      context 'when the document represents A/V media' do
        let(:document) do
          super().merge(
            'compound_objects_ts' => <<~JSON
              [{
                "pageptr": 321,
                "title": "Video Thing",
                "transc": "The text",
                "pagefile": "foo.mp4"
              }]
            JSON
          )
        end

        it { is_expected.to eq('/iiif/foo:123/manifest.json') }
      end
    end
  end
end
