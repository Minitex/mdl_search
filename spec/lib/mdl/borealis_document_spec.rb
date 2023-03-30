require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_image.rb'
require_relative '../../../lib/mdl/borealis_audio.rb'
require_relative '../../../lib/mdl/borealis_video.rb'
require_relative '../../../lib/mdl/borealis_pdf.rb'
require_relative '../../../lib/mdl/borealis_asset_map.rb'
require_relative '../../../lib/mdl/borealis_document.rb'
require_relative '../../../lib/mdl/borealis_ppt.rb'

module MDL
  describe BorealisDocument do
    let(:asset_klass) { double }
    let(:document) do
      {'id' => 'foo:123', 'format' => 'image/jp2', 'title_ssi' => 'blerg'}
    end
    let(:compound_document) do
      document.merge('compound_objects_ts' => <<~JSON
        [
          {
            "pageptr": 123,
            "title": "Some thing",
            "transc": "blah",
            "pagefile": "foo.jp2"
          },
          {
            "pageptr": 321,
            "title": "Another Thing",
            "transc": "The text",
            "pagefile": "foo.mp4"
          }
        ]
      JSON
      )
    end
    let(:bogus_pagefile) do
      document.merge('compound_objects_ts' => <<~JSON
        [
          {
            "pageptr": 123,
            "title": "Some thing",
            "transc": "blah",
            "pagefile": {}
          },
         {
            "pageptr": 321,
            "title": "Another Thing",
            "transc": "The text",
            "pagefile": "foo.jp2"
          }
        ]
      JSON
      )
    end

    describe '#manifest_url' do
      subject do
        BorealisDocument.new(document: document).manifest_url
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
