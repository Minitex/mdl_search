require 'spec_helper'
require_relative '../../../lib/mdl/download_asset'

describe MDL::DownloadAsset do
  describe '.from_iiif_canvas' do
    let(:canvas) do
      {
        "@id" => "https://cdm16022.contentdm.oclc.org/iiif/p16022coll64:4803/canvas/c22",
        "@type" => "sc:Canvas",
        "label" => "Page 15",
        "images" => [
          {
            "@id" => "https://cdm16022.contentdm.oclc.org/iiif/p16022coll64:4803/annotation/a22",
            "@type" => "oa:Annotation",
            "motivation" => "sc:painting",
            "resource" => {
              "@id" => "https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/full/0/default.jpg",
              "@type" => "dctypes:Image",
              "service" => {
                "@context" => "http://iiif.io/api/image/2/context.json",
                "@id" => "https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803",
                "width" => 1921,
                "height" => 2966,
                "tiles" => [
                  {
                    "width" => 1921,
                    "scaleFactors" => [1, 2, 4, 8, 16]
                  }
                ],
                "profile" => "http://iiif.io/api/image/2/level1.json",
                "protocol" => "http://iiif.io/api/image"
              },
              "format" => "image/jpeg",
              "width" => 1921,
              "height" => 2966
            },
            "on" => "https://cdm16022.contentdm.oclc.org/iiif/p16022coll64:4803/canvas/c22"
          }
        ],
        "width" => 1921,
        "height" => 2966
      }
    end

    it 'returns a DownloadAsset instance' do
      instance = MDL::DownloadAsset.from_iiif_canvas(canvas)

      expect(instance).to be_a(MDL::DownloadAsset)
      expect(instance.label).to eq('Page 15')
      expect(instance.thumbnail).to eq(
        'https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/90,/0/default.jpg'
      )
      small, large = instance.downloads

      expect(small[:label]).to eq('Small')
      expect(large[:label]).to eq('Large')
      expect(small[:src]).to eq(
        'https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/150,/0/default.jpg'
      )
      expect(large[:src]).to eq(
        'https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/800,/0/default.jpg'
      )
    end
  end
end
