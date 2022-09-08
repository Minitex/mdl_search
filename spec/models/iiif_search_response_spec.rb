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
        expect(r1['resource']['chars']).to eq('“COURT')
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
        expect(h1['match']).to eq('“COURT')
        expect(h1['before']).to eq('')
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
        expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/search?q=The+reasoning+of')
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

    context 'multiple matches per line' do
      let(:fixture_file) do
        'iiif_search_response_multiple_matches_per_line.json'
      end
      let(:result) do
        IiifSearchResponse.new(
          solr_response,
          query: 'was',
          item_id: 'pch:1224'
        ).as_json
      end

      it 'forms the correct structure' do
        expect(result['@context']).to eq('http://iiif.io/api/search/1/context.json')
        expect(result['@id']).to eq('https://collection.mndigital.org/iiif/pch:1224/search?q=was')
        expect(result['@type']).to eq('sc:AnnotationList')
        expect(result['within']['@type']).to eq('sc:Layer')
        expect(result['within']['total']).to eq(9)
        expect(result['startIndex']).to eq(0)
        expect(result['resources']).to be_an(Array)
        expect(result['hits']).to be_an(Array)
      end

      describe 'resources' do
        it 'represents each distinct match within a line' do
          expect(result['resources'].size).to eq(9)

          r1, r2, r3 = result['resources'].take(3)
          expect(r1['@id']).to eq(
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h971,1091,91,34'
          )
          expect(r1['@type']).to eq('oa:Annotation')
          expect(r1['motivation']).to eq('sc:painting')
          expect(r1['resource']['@type']).to eq('cnt:ContentAsText')
          expect(r1['resource']['chars']).to eq('was')
          expect(r1['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=971,1091,91,34')

          expect(r2['@id']).to eq(
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1591,1084,92,28'
          )
          expect(r2['@type']).to eq('oa:Annotation')
          expect(r2['motivation']).to eq('sc:painting')
          expect(r2['resource']['@type']).to eq('cnt:ContentAsText')
          expect(r2['resource']['chars']).to eq('was')
          expect(r2['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=1591,1084,92,28')

          expect(r3['@id']).to eq(
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h2568,1070,93,29'
          )
          expect(r3['@type']).to eq('oa:Annotation')
          expect(r3['motivation']).to eq('sc:painting')
          expect(r3['resource']['@type']).to eq('cnt:ContentAsText')
          expect(r3['resource']['chars']).to eq('was')
          expect(r3['on']).to eq('https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0#xywh=2568,1070,93,29')
        end
      end

      describe 'hits' do
        it 'represents each distinct match within a line' do
          expect(result['hits'].size).to eq(9)
          h1, h2, h3 = result['hits'].take(3)

          expect(h1['@type']).to eq('search:Hit')
          expect(h1['annotations']).to eq([
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h971,1091,91,34'
          ])
          expect(h1['match']).to eq('was')
          expect(h1['before']).to eq('freedom fighter, who')
          expect(h1['after']).to eq('also arrested, was released on Sunday). Bail was')

          expect(h2['@type']).to eq('search:Hit')
          expect(h2['annotations']).to eq([
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h1591,1084,92,28'
          ])
          expect(h2['match']).to eq('was')
          expect(h2['before']).to eq('freedom fighter, who was also arrested,')
          expect(h2['after']).to eq('released on Sunday). Bail was')

          expect(h3['@type']).to eq('search:Hit')
          expect(h3['annotations']).to eq([
            'https://collection.mndigital.org/annotations/pch:1224/canvas/c0/h2568,1070,93,29'
          ])
          expect(h3['match']).to eq('was')
          expect(h3['before']).to eq('freedom fighter, who was also arrested, was released on Sunday). Bail')
          expect(h3['after']).to eq('')
        end
      end
    end
  end

  describe IiifSearchResponse::Match do
    describe '.expand' do
      let(:result) do
        IiifSearchResponse::Match.expand(JSON.parse(doc), highlights)
      end

      context 'when the highlights don\'t represent the whole line' do
        let(:doc) do
          <<~JSON
            {
              "id": "3984261607078160215-29",
              "item_id": "pch:1224",
              "line": "in front of a jury. The minor who was arrested will be receiving a court",
              "canvas_id": "https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0",
              "word_boundaries": {
                "0": { "x0": 295, "y0": 2018, "x1": 356, "y1": 2056, "c": 96 },
                "1": { "x0": 397, "y0": 2017, "x1": 549, "y1": 2056, "c": 95 },
                "2": { "x0": 588, "y0": 2017, "x1": 649, "y1": 2056, "c": 96 },
                "3": { "x0": 686, "y0": 2026, "x1": 716, "y1": 2055, "c": 96 },
                "4": { "x0": 755, "y0": 2016, "x1": 904, "y1": 2063, "c": 87 },
                "5": { "x0": 944, "y0": 2014, "x1": 1038, "y1": 2061, "c": 96 },
                "6": { "x0": 1077, "y0": 2014, "x1": 1235, "y1": 2051, "c": 96 },
                "7": { "x0": 1273, "y0": 2012, "x1": 1364, "y1": 2048, "c": 96 },
                "8": { "x0": 1403, "y0": 2018, "x1": 1496, "y1": 2046, "c": 96 },
                "9": { "x0": 1535, "y0": 2004, "x1": 1791, "y1": 2055, "c": 96 },
                "10": { "x0": 1828, "y0": 2003, "x1": 1952, "y1": 2041, "c": 96 },
                "11": { "x0": 1991, "y0": 2001, "x1": 2050, "y1": 2038, "c": 96 },
                "12": { "x0": 2064, "y0": 1998, "x1": 2378, "y1": 2052, "c": 96 },
                "13": { "x0": 2415, "y0": 2004, "x1": 2444, "y1": 2032, "c": 96 },
                "14": { "x0": 2481, "y0": 1991, "x1": 2636, "y1": 2031, "c": 95 }
              }
            }
          JSON
        end

        context 'and come at the beginning' do
          let(:highlights) do
            'in front of a <em>jury.</em>'
          end

          it 'contains a single match' do
            expect(result.size).to eq(1)
          end

          it 'has the right coordinates' do
            expect(result[0].xywh).to eq('755,2016,149,47')
          end

          it 'identifies the text before' do
            expect(result[0].text_before).to eq('in front of a')
          end

          it 'identifies the text after' do
            expect(result[0].text_after).to eq(
              'The minor who was arrested will be receiving a court'
            )
          end

          it 'identifies the matching text' do
            expect(result[0].text_match).to eq('jury.')
          end
        end

        context 'and come in the middle' do
          let(:highlights) do
            'The minor who was <em>arrested</em>'
          end

          it 'contains a single match' do
            expect(result.size).to eq(1)
          end

          it 'has the right coordinates' do
            expect(result[0].xywh).to eq('1535,2004,256,51')
          end

          it 'identifies the text before' do
            expect(result[0].text_before).to eq(
              'in front of a jury. The minor who was'
            )
          end

          it 'identifies the text after' do
            expect(result[0].text_after).to eq('will be receiving a court')
          end

          it 'identifies the matching text' do
            expect(result[0].text_match).to eq('arrested')
          end
        end
      end

      context 'when a single word in a line is matched' do
        let(:doc) do
          <<~JSON
            {
              "id": "3984261607078160215-29",
              "item_id": "pch:1224",
              "line": "in front of a jury. The minor who was arrested will be receiving a court",
              "canvas_id": "https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0",
              "word_boundaries": {
                "0": { "x0": 295, "y0": 2018, "x1": 356, "y1": 2056, "c": 96 },
                "1": { "x0": 397, "y0": 2017, "x1": 549, "y1": 2056, "c": 95 },
                "2": { "x0": 588, "y0": 2017, "x1": 649, "y1": 2056, "c": 96 },
                "3": { "x0": 686, "y0": 2026, "x1": 716, "y1": 2055, "c": 96 },
                "4": { "x0": 755, "y0": 2016, "x1": 904, "y1": 2063, "c": 87 },
                "5": { "x0": 944, "y0": 2014, "x1": 1038, "y1": 2061, "c": 96 },
                "6": { "x0": 1077, "y0": 2014, "x1": 1235, "y1": 2051, "c": 96 },
                "7": { "x0": 1273, "y0": 2012, "x1": 1364, "y1": 2048, "c": 96 },
                "8": { "x0": 1403, "y0": 2018, "x1": 1496, "y1": 2046, "c": 96 },
                "9": { "x0": 1535, "y0": 2004, "x1": 1791, "y1": 2055, "c": 96 },
                "10": { "x0": 1828, "y0": 2003, "x1": 1952, "y1": 2041, "c": 96 },
                "11": { "x0": 1991, "y0": 2001, "x1": 2050, "y1": 2038, "c": 96 },
                "12": { "x0": 2064, "y0": 1998, "x1": 2378, "y1": 2052, "c": 96 },
                "13": { "x0": 2415, "y0": 2004, "x1": 2444, "y1": 2032, "c": 96 },
                "14": { "x0": 2481, "y0": 1991, "x1": 2636, "y1": 2031, "c": 95 }
              }
            }
          JSON
        end
        let(:highlights) do
          'The minor who was arrested will be receiving a <em>court</em>'
        end

        it 'contains a single match' do
          expect(result.size).to eq(1)
        end

        it 'has the right coordinates' do
          expect(result[0].xywh).to eq('2481,1991,155,40')
        end

        it 'identifies the text before' do
          expect(result[0].text_before).to eq(
            'in front of a jury. The minor who was arrested will be receiving a'
          )
        end

        it 'identifies the text after' do
          expect(result[0].text_after).to eq('')
        end

        it 'identifies the matching text' do
          expect(result[0].text_match).to eq('court')
        end
      end

      context 'when a single word is matched multiple times' do
        let(:doc) do
          <<~JSON
            {
              "id": "9d404854-3c5d-4bf8-9b9d-c08e8e70762a-12",
              "item_id": "pch:1224",
              "line": "freedom fighter, who was also arrested, was released on Sunday). Bail was",
              "canvas_id": "https://cdm16022.contentdm.oclc.org/iiif/pch:1224/canvas/c0",
              "word_boundaries": {
                "0": { "x0": 290, "y0": 1086, "x1": 511, "y1": 1125, "c": 96 },
                "1": { "x0": 551, "y0": 1083, "x1": 796, "y1": 1135, "c": 96 },
                "2": { "x0": 840, "y0": 1082, "x1": 930, "y1": 1122, "c": 96 },
                "3": { "x0": 971, "y0": 1091, "x1": 1062, "y1": 1125, "c": 95 },
                "4": { "x0": 1102, "y0": 1080, "x1": 1224, "y1": 1119, "c": 95 },
                "5": { "x0": 1265, "y0": 1076, "x1": 1546, "y1": 1125, "c": 96 },
                "6": { "x0": 1591, "y0": 1084, "x1": 1683, "y1": 1112, "c": 95 },
                "7": { "x0": 1722, "y0": 1071, "x1": 1977, "y1": 1122, "c": 93 },
                "8": { "x0": 2015, "y0": 1077, "x1": 2075, "y1": 1107, "c": 95 },
                "9": { "x0": 2084, "y0": 1060, "x1": 2363, "y1": 1112, "c": 92 },
                "10": { "x0": 2404, "y0": 1063, "x1": 2530, "y1": 1110, "c": 95 },
                "11": { "x0": 2568, "y0": 1070, "x1": 2661, "y1": 1099, "c": 96 }
              }
            }
          JSON
        end
        let(:highlights) do
          'freedom fighter, who <em>was</em> also arrested, <em>was</em> released on Sunday). Bail <em>was</em>'
        end

        it 'contains multiple matches' do
          expect(result.size).to eq(3)
        end

        it 'each match has the right coordinates' do
          m1, m2, m3 = result
          expect(m1.xywh).to eq('971,1091,91,34')
          expect(m2.xywh).to eq('1591,1084,92,28')
          expect(m3.xywh).to eq('2568,1070,93,29')
        end

        it 'identifies the text before' do
          m1, m2, m3 = result
          expect(m1.text_before).to eq(
            'freedom fighter, who'
          )
          expect(m2.text_before).to eq(
            'freedom fighter, who was also arrested,'
          )
          expect(m3.text_before).to eq(
            'freedom fighter, who was also arrested, was released on Sunday). Bail'
          )
        end

        it 'identifies the text after' do
          m1, m2, m3 = result
          expect(m1.text_after).to eq(
            'also arrested, was released on Sunday). Bail was'
          )
          expect(m2.text_after).to eq(
            'released on Sunday). Bail was'
          )
          expect(m3.text_after).to eq('')
        end

        it 'identifies the matching text' do
          m1, m2, m3 = result
          expect(m1.text_match).to eq('was')
          expect(m2.text_match).to eq('was')
          expect(m3.text_match).to eq('was')
        end
      end

      context 'with a phrase' do
      end
    end
  end
end
