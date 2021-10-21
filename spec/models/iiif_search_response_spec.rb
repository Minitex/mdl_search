require 'rails_helper'

describe IiifSearchResponse do
  describe '#as_json' do
    let(:fixture_file) { 'iiif_search_response.json' }
    let(:solr_response) do
      fixture_path = Rails.root.join(
        'spec',
        'fixtures',
        'solr',
        fixture_file
      )
      JSON.parse(IO.read(fixture_path))
    end
    let(:result) do
      IiifSearchResponse.new(
        solr_response,
        query: 'court',
        item_id: 'pch:1224'
      ).as_json
    end

    it 'forms the correct structure' do
      expect(result['@context']).to eq('http://iiif.io/api/search/1/context.json')
      expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/search?q=court')
      expect(result['@type']).to eq('sc:AnnotationList')
      expect(result['within']['@type']).to eq('sc:Layer')
      expect(result['within']['total']).to eq(4)
      expect(result['startIndex']).to eq(0)
      expect(result['resources']).to be_an(Array)
      expect(result['hits']).to be_an(Array)
    end

    describe 'resources' do
      it 'forms the correct structure' do
        expect(result['resources'].size).to eq(4)
        r1, r2, r3, r4 = result['resources']

        expect(r1['@id']).to eq(
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1335,340,182,63'
        )
        expect(r1['@type']).to eq('oa:Annotation')
        expect(r1['motivation']).to eq('sc:painting')
        expect(r1['resource']['@type']).to eq('cnt:ContentAsText')
        expect(r1['resource']['chars']).to eq('COURT')
        expect(r1['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=1335,340,182,63')

        expect(r2['@id']).to eq(
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h772,440,156,42'
        )
        expect(r2['@type']).to eq('oa:Annotation')
        expect(r2['motivation']).to eq('sc:painting')
        expect(r2['resource']['@type']).to eq('cnt:ContentAsText')
        expect(r2['resource']['chars']).to eq('court')
        expect(r2['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=772,440,156,42')

        expect(r3['@id']).to eq(
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h2481,1991,155,40'
        )
        expect(r3['@type']).to eq('oa:Annotation')
        expect(r3['motivation']).to eq('sc:painting')
        expect(r3['resource']['@type']).to eq('cnt:ContentAsText')
        expect(r3['resource']['chars']).to eq('court')
        expect(r3['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=2481,1991,155,40')

        expect(r4['@id']).to eq(
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1046,2127,156,40'
        )
        expect(r4['@type']).to eq('oa:Annotation')
        expect(r4['motivation']).to eq('sc:painting')
        expect(r4['resource']['@type']).to eq('cnt:ContentAsText')
        expect(r4['resource']['chars']).to eq('Court')
        expect(r4['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=1046,2127,156,40')
      end
    end

    describe 'hits' do
      it 'forms the correct structure' do
        expect(result['hits'].size).to eq(4)
        h1, h2, h3, h4 = result['hits']

        expect(h1['@type']).to eq('search:Hit')
        expect(h1['annotations']).to eq([
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1335,340,182,63'
        ])
        expect(h1['match']).to eq('COURT')
        expect(h1['before']).to eq('“')
        expect(h1['after']).to eq('CAPERS')

        expect(h2['@type']).to eq('search:Hit')
        expect(h2['annotations']).to eq([
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h772,440,156,42'
        ])
        expect(h2['match']).to eq('court')
        expect(h2['before']).to eq('We have 2')
        expect(h2['after']).to eq('appearances this week, with Tom Marthaler coming up on')

        expect(h3['@type']).to eq('search:Hit')
        expect(h3['annotations']).to eq([
          'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h2481,1991,155,40'
        ])
        expect(h3['match']).to eq('court')
        expect(h3['before']).to eq('in front of a jury. The minor who was arrested will be receiving a')
        expect(h3['after']).to eq('')
      end
    end

    context 'searching for a multi-word phrase' do
      let(:fixture_file) { 'iiif_search_response_phrase.json' }
      let(:result) do
        IiifSearchResponse.new(
          solr_response,
          query: 'The reasoning of',
          item_id: 'pch:1224'
        ).as_json
      end

      it 'forms the correct structure' do
        expect(result['@context']).to eq('http://iiif.io/api/search/1/context.json')
        expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/search?q=The%20reasoning%20of')
        expect(result['@type']).to eq('sc:AnnotationList')
        expect(result['within']['@type']).to eq('sc:Layer')
        expect(result['within']['total']).to eq(1)
        expect(result['startIndex']).to eq(0)
        expect(result['resources']).to be_an(Array)
        expect(result['hits']).to be_an(Array)
      end

      describe 'resources' do
        it 'forms the correct structure' do
          expect(result['resources'].size).to eq(1)
          r1 = result['resources'].first

          expect(r1['@id']).to eq(
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1794,1126,542,47'
          )
          expect(r1['@type']).to eq('oa:Annotation')
          expect(r1['motivation']).to eq('sc:painting')
          expect(r1['resource']['@type']).to eq('cnt:ContentAsText')
          expect(r1['resource']['chars']).to eq('The reasoning of')
          expect(r1['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=1794,1126,542,47')
        end
      end

      describe 'hits' do
        it 'forms the correct structure' do
          expect(result['hits'].size).to eq(1)
          hit = result['hits'].first

          expect(hit['@type']).to eq('search:Hit')
          expect(hit['annotations']).to eq([
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1794,1126,542,47'
          ])
          expect(hit['match']).to eq('The reasoning of')
          expect(hit['before']).to eq('set at $500 for 15 and $1000 for the 4 others,')
          expect(hit['after']).to eq('the prosecut-')
        end
      end
    end
  end
end
