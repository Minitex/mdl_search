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
            ]
          }
        ])
        expect(result['rendering'][0]['id']).to eq('https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll548/id/1193/filename')
        expect(result['rendering'][0]['type']).to eq('Text')
        expect(result['rendering'][0]['label']['en']).to eq(['PDF Transcript'])
        expect(result['rendering'][0]['format']).to eq('application/pdf')
      end
    end
  end
end
