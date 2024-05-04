require 'rails_helper'

describe MDL::DownloadAsset do
  describe '.assets_from_manifest_v2' do
    let(:manifest_v2) do
      {
        '@context' => 'http://iiif.io/api/presentation/2/context.json',
        'sequences' => [{
          'canvases' => [{
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
          }]
        }]
      }
    end

    it 'returns DownloadAsset instances' do
      assets = described_class.assets_from_manifest_v2(manifest_v2)
      expect(assets.size).to eq(1)

      instance = assets.first

      expect(instance).to be_a(MDL::DownloadAsset)
      expect(instance.label).to eq('Page 15')
      expect(instance.thumbnail).to eq(
        'https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/90,/0/default.jpg'
      )
      expect(instance.download.label).to eq('Page 15')
      expect(instance.download.src).to eq(
        'https://cdm16022.contentdm.oclc.org/iiif/2/p16022coll64:4803/full/800,/0/default.jpg'
      )
    end
  end

  describe '.assets_from_manifest_v3' do
    let(:manifest_v3) do
      IiifManifest.new(doc, base_url: 'collection.mndigital.com').as_json
    end

    context 'with a playlist' do
      let(:doc) { build(:borealis_document, :video_playlist) }

      it 'returns DownloadAsset instances' do
        assets = described_class.assets_from_manifest_v3(manifest_v3)
        expect(assets.size).to eq(5)

        part1, part2, part3, part4, transcript = assets
        expect(part1.download.src).to eq('https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_or91f5dp/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4')
        expect(part1.download.label).to eq('Video Part 1')
        expect(part1.label).to eq('Video Part 1')
        expect(part1.thumbnail).to eq(MDL::Thumbnail::DEFAULT_VIDEO_URL)

        expect(part2.download.src).to eq('https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_nfct7x5c/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4')
        expect(part2.download.label).to eq('Video Part 2')
        expect(part2.label).to eq('Video Part 2')
        expect(part2.thumbnail).to eq(MDL::Thumbnail::DEFAULT_VIDEO_URL)

        expect(part3.download.src).to eq('https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_0wmrqvpc/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4')
        expect(part3.download.label).to eq('Video Part 3')
        expect(part3.label).to eq('Video Part 3')
        expect(part3.thumbnail).to eq(MDL::Thumbnail::DEFAULT_VIDEO_URL)

        expect(part4.download.src).to eq('https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_ivkawv6u/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4')
        expect(part4.download.label).to eq('Video Part 4')
        expect(part4.label).to eq('Video Part 4')
        expect(part4.thumbnail).to eq(MDL::Thumbnail::DEFAULT_VIDEO_URL)

        expect(transcript.download.src).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll548/id/1120/filename')
        expect(transcript.download.label).to eq('Transcript')
        expect(transcript.label).to eq('Transcript')
        expect(transcript.thumbnail).to eq('https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll548/id/1120')
      end
    end

    context 'with a single A/V file' do
      let(:doc) { build(:borealis_document, :video) }

      it 'returns DownloadAsset instances' do
        assets = described_class.assets_from_manifest_v3(manifest_v3)
        expect(assets.size).to eq(2)

        video, transcript = assets

        expect(video.download.src).to eq('https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_fisppzr2/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4')
        expect(video.download.label).to eq('Video')
        expect(video.label).to eq('Video')
        expect(video.thumbnail).to eq(MDL::Thumbnail::DEFAULT_VIDEO_URL)

        expect(transcript.download.src).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/sll/id/22547/filename')
        expect(transcript.download.label).to eq('Transcript')
        expect(transcript.label).to eq('Transcript')
        expect(transcript.thumbnail).to eq('https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/sll/id/22547')
      end
    end
  end
end
