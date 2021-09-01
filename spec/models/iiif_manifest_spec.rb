require 'rails_helper'

describe IiifManifest do
  describe '#as_json' do
    let(:instance) { IiifManifest.new(doc) }

    context 'with a video doc' do
      let(:doc) { build(:borealis_document, :video) }

      it 'generates the expected structure' do
        result = instance.as_json
        expect(result['@context']).to eq('http://iiif.io/api/presentation/3/context.json')
        expect(result['id']).to eq('https://collection.mndigital.org/iiif/info/sll/22548/manifest.json')
        expect(result['type']).to eq('Manifest')
        expect(result['label']['en']).to eq(['Interview with Alan Page, Minnesota Supreme Court Historical Society Oral History Project, St. Paul, Minnesota'])
        expect(result['rights']).to eq('http://rightsstatements.org/vocab/InC/1.0/')
        expect(result['provider'][0]['id']).to eq('https://mn.gov/law-library/')
        expect(result['provider'][0]['type']).to eq('Agent')
        expect(result['provider'][0]['label']['en']).to eq([
          'Minnesota State Law Library',
          'G25 Minnesota Judicial Center',
          '25 Rev. Dr. Martin Luther King Jr. Blvd',
          'St. Paul',
          'MN 55155'
        ])
        expect(result['items']).to eq([
          {
            'id' => 'https://collection.mndigital.org/iiif/info/sll/22548/canvas/0',
            'type' => 'Canvas',
            'height' => 480,
            'width' => 640,
            'duration' => 7260,
            'items' => [
              {
                'id' => 'https://collection.mndigital.org/iiif/info/sll/22548/canvas/0/page',
                'type' => 'AnnotationPage',
                'items' => [
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/sll/22548/canvas/0/page/annotation',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_fisppzr2/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'type' => 'Video',
                      'height' => 480,
                      'width' => 640,
                      'duration' => 7260,
                      'format' => 'video/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/sll/22548/canvas/0'
                  }
                ]
              }
            ],
            'thumbnail' => [
              {
                'id' => '/images/video-1.png',
                'type' => 'Image',
                'format' => 'image/png',
                'width' => 160,
                'height' => 160
              }
            ]
          }
        ])
        expect(result['rendering'][0]['id']).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/sll/id/22547/filename')
        expect(result['rendering'][0]['type']).to eq('Text')
        expect(result['rendering'][0]['label']['en']).to eq(['PDF Transcript'])
        expect(result['rendering'][0]['format']).to eq('application/pdf')
      end
    end

    context 'with an audio doc' do
      let(:doc) { build(:borealis_document, :audio) }

      it 'generates the expected structure' do
        result = instance.as_json
        expect(result['@context']).to eq('http://iiif.io/api/presentation/3/context.json')
        expect(result['id']).to eq('https://collection.mndigital.org/iiif/info/p16022coll548/1194/manifest.json')
        expect(result['type']).to eq('Manifest')
        expect(result['label']['en']).to eq(['Interview with Naomi Silfversten and Ruth Silfversten Coppins'])
        expect(result['rights']).to eq('http://rightsstatements.org/vocab/InC/1.0/')
        expect(result['provider'][0]['id']).to eq('http://mndiscoverycenter.com/research-center')
        expect(result['provider'][0]['type']).to eq('Agent')
        expect(result['provider'][0]['label']['en']).to eq([
          'Minnesota Discovery Center',
          '1005 Discovery Drive',
          'Chisholm',
          'Minnesota 55719'
        ])
        expect(result['items']).to eq([
          {
            'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1194/canvas/0',
            'type' => 'Canvas',
            'duration' => 3734,
            'items' => [
              {
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1194/canvas/0/page',
                'type' => 'AnnotationPage',
                'items' => [
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1194/canvas/0/page/annotation',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_i1bal3lz/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4',
                      'type' => 'Sound',
                      'duration' => 3734,
                      'format' => 'audio/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1194/canvas/0'
                  }
                ]
              }
            ],
            'thumbnail' => [
              {
                'id' => '/images/audio-3.png',
                'type' => 'Image',
                'format' => 'image/png',
                'width' => 160,
                'height' => 160
              }
            ]
          }
        ])
        expect(result['rendering'][0]['id']).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll548/id/1193/filename')
        expect(result['rendering'][0]['type']).to eq('Text')
        expect(result['rendering'][0]['label']['en']).to eq(['PDF Transcript'])
        expect(result['rendering'][0]['format']).to eq('application/pdf')
      end
    end

    context 'with a video playlist doc' do
      let(:doc) { build(:borealis_document, :video_playlist) }

      it 'generates the expected structure' do
        result = instance.as_json
        expect(result['@context']).to eq('http://iiif.io/api/presentation/3/context.json')
        expect(result['id']).to eq('https://collection.mndigital.org/iiif/info/p16022coll548/1121/manifest.json')
        expect(result['type']).to eq('Manifest')
        expect(result['label']['en']).to eq(['Interview with Chamreun Tan'])
        expect(result['rights']).to eq('http://www.mnhs.org/copyright')
        expect(result['provider'][0]['id']).to eq('http://www.mnhs.org')
        expect(result['provider'][0]['type']).to eq('Agent')
        expect(result['provider'][0]['label']['en']).to eq([
          'Minnesota Historical Society',
          '345 Kellogg Boulevard West',
          'St. Paul',
          'MN 51102-1906'
        ])
        expect(result['rendering'][0]['id']).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll548/id/1120/filename')
        expect(result['rendering'][0]['type']).to eq('Text')
        expect(result['rendering'][0]['label']['en']).to eq(['PDF Transcript'])
        expect(result['rendering'][0]['format']).to eq('application/pdf')
        expect(result['items']).to eq([
          {
            'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0',
            'type' => 'Canvas',
            'height' => 480,
            'width' => 640,
            'duration' => 4190,
            'items' => [
              {
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0/page',
                'type' => 'AnnotationPage',
                'items' => [
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0/page/annotation/0',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_or91f5dp/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'type' => 'Video',
                      'height' => 480,
                      'width' => 640,
                      'duration' => 387,
                      'format' => 'video/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=0,387'
                  },
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0/page/annotation/1',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_nfct7x5c/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'type' => 'Video',
                      'height' => 480,
                      'width' => 640,
                      'duration' => 1876,
                      'format' => 'video/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=387,2263'
                  },
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0/page/annotation/2',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_0wmrqvpc/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'type' => 'Video',
                      'height' => 480,
                      'width' => 640,
                      'duration' => 1699,
                      'format' => 'video/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=2263,3962'
                  },
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0/page/annotation/3',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_ivkawv6u/flavorId/1_uivmmxof/format/url/protocol/http/a.mp4',
                      'type' => 'Video',
                      'height' => 480,
                      'width' => 640,
                      'duration' => 228,
                      'format' => 'video/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=3962,4190'
                  }
                ]
              }
            ],
            'thumbnail' => [
              {
                'id' => '/images/video-1.png',
                'type' => 'Image',
                'format' => 'image/png',
                'width' => 160,
                'height' => 160
              }
            ]
          }
        ])
        expect(result['structures']).to eq([
          {
            'type' => 'Range',
            'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/range/0',
            'label' => {
              'en' => ['Interview with Chamreun Tan']
            },
            'items' => [
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/range/0.0',
                'label' => {
                  'en' => ['Interview with Chamreun Tan, Part 1']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=0,387'
                  }
                ]
              },
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/range/0.1',
                'label' => {
                  'en' => ['Interview with Chamreun Tan, Part 2']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=387,2263'
                  }
                ]
              },
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/range/0.2',
                'label' => {
                  'en' => ['Interview with Chamreun Tan, Part 3']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=2263,3962'
                  }
                ]
              },
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/range/0.3',
                'label' => {
                  'en' => ['Interview with Chamreun Tan, Part 4']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1121/canvas/0#t=3962,4190'
                  }
                ]
              }
            ]
          }
        ])
      end
    end

    context 'with a audio playlist doc' do
      let(:doc) { build(:borealis_document, :audio_playlist) }

      it 'generates the expected structure' do
        result = instance.as_json
        expect(result['@context']).to eq('http://iiif.io/api/presentation/3/context.json')
        expect(result['id']).to eq('https://collection.mndigital.org/iiif/info/p16022coll548/1013/manifest.json')
        expect(result['type']).to eq('Manifest')
        expect(result['label']['en']).to eq(['Interview with John Choi'])
        expect(result['rights']).to eq('http://www.mnhs.org/copyright')
        expect(result['provider'][0]['id']).to eq('http://www.mnhs.org')
        expect(result['provider'][0]['type']).to eq('Agent')
        expect(result['provider'][0]['label']['en']).to eq([
          'Minnesota Historical Society',
          '345 Kellogg Boulevard West',
          'St. Paul',
          'MN 51102-1906'
        ])
        expect(result['rendering'][0]['id']).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll548/id/1012/filename')
        expect(result['rendering'][0]['type']).to eq('Text')
        expect(result['rendering'][0]['label']['en']).to eq(['PDF Transcript'])
        expect(result['rendering'][0]['format']).to eq('application/pdf')
        expect(result['items']).to eq([
          {
            'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0',
            'type' => 'Canvas',
            'duration' => 4181,
            'items' => [
              {
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0/page',
                'type' => 'AnnotationPage',
                'items' => [
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0/page/annotation/0',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_m9tvjl6o/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4',
                      'type' => 'Sound',
                      'duration' => 1812,
                      'format' => 'audio/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=0,1812'
                  },
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0/page/annotation/1',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_vpgan6fg/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4',
                      'type' => 'Sound',
                      'duration' => 1898,
                      'format' => 'audio/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=1812,3710'
                  },
                  {
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0/page/annotation/2',
                    'type' => 'Annotation',
                    'motivation' => 'painting',
                    'body' => {
                      'id' => 'http://cdnbakmi.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/1_zz7vf4az/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4',
                      'type' => 'Sound',
                      'duration' => 471,
                      'format' => 'audio/mp4'
                    },
                    'target' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=3710,4181'
                  }
                ]
              }
            ],
            'thumbnail' => [
              {
                'id' => '/images/audio-3.png',
                'type' => 'Image',
                'format' => 'image/png',
                'width' => 160,
                'height' => 160
              }
            ]
          }
        ])
        expect(result['structures']).to eq([
          {
            'type' => 'Range',
            'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/range/0',
            'label' => {
              'en' => ['Interview with John Choi']
            },
            'items' => [
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/range/0.0',
                'label' => {
                  'en' => ['Interview with John Choi, Part 1']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=0,1812'
                  }
                ]
              },
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/range/0.1',
                'label' => {
                  'en' => ['Interview with John Choi, Part 2']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=1812,3710'
                  }
                ]
              },
              {
                'type' => 'Range',
                'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/range/0.2',
                'label' => {
                  'en' => ['Interview with John Choi, Part 3']
                },
                'items' => [
                  {
                    'type' => 'Canvas',
                    'id' => 'https://collection.mndigital.org/iiif/info/p16022coll548/1013/canvas/0#t=3710,4181'
                  }
                ]
              }
            ]
          }
        ])
      end
    end
  end
end
