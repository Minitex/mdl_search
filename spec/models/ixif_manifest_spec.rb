require 'rails_helper'

describe IxifManifest do
  describe '#as_json' do
    let(:instance) { IxifManifest.new(doc) }

    context 'with a video and transcription' do
      let(:doc) { FactoryGirl.build(:borealis_document, :video) }

      it 'generates the correct hash' do
        expected = {
          '@context' => [
            'http://iiif.io/api/presentation/2/context.json'
          ],
          '@id' => 'https://collection.mndigital.org/iiif/info/sll/22548/manifest.json',
          '@type' => 'sc:Manifest',
          'label' => 'Interview with Alan Page, Minnesota Supreme Court Historical Society Oral History Project, St. Paul, Minnesota',
          'metadata' => [],
          'mediaSequences' => [
            {
              '@id' => 'https://collection.mndigital.org/iiif/info/sll/22548/xsequence/0',
              '@type' => 'ixif:MediaSequence',
              'label' => 'XSequence 0',
              'elements' => [
                {
                  'id' =>
                  'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_fisppzr2/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4#identity',
                  '@type' => 'dctypes:MovingImage',
                  'format' => 'video/mp4',
                  'label' => 'Interview with Alan Page, Minnesota Supreme Court Historical Society Oral History Project, St. Paul, Minnesota',
                  'metadata' => [{'label' => 'length', 'value' => '7260 s'}],
                  'rendering' => [
                    {
                      '@id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_fisppzr2/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'format' => 'video/mp4'
                    }
                  ],
                  'resources' => [
                    {
                      '@id' => 'https://collection.mndigital.org/iiif/info/sll/22548/canvases/22547/supplementing',
                      '@type' => 'oa:Annotation',
                      'motivation' => 'oad:transcribing',
                      'resource' => {
                        '@id' => 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/sll/id/22547/filename',
                        '@type' => 'foaf:Document',
                        'format' => 'application/pdf',
                        'label' => 'Interview with Alan Page, Minnesota Supreme Court Historical Society Oral History Project, St. Paul, Minnesota',
                        'thumbnail' => '/images/reflections-pdf-icon.png'
                      },
                      'on' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_fisppzr2/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4#identity'
                    }
                  ]
                }
              ]
            }
          ]
        }
        expect(instance.as_json).to eq(expected)
      end
    end
  end
end
