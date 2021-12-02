require 'rails_helper'
require_relative '../../../lib/mdl/multi_date_formatter'

module MDL
  describe IiifManifestFormatter do
    describe '.format' do
      let(:manifest) do
        <<~JSON
          {
            "sequences": [{
              "canvases": [{}]
            }]
          }
        JSON
      end
      let(:mock_response) do
        double('response', code: '200', body: manifest)
      end
      let(:doc) do
        {
          'id' => 'pch/1224',
          'format' => 'image/jp2',
        }
      end

      before do
        allow(Net::HTTP).to receive(:get_response)
          .and_return(mock_response)
      end

      it 'adds the service description to the manifest' do
        result = described_class.format(doc)
        parsed_result = JSON.parse(result)
        expect(parsed_result['service']).to eq({
          '@context' => 'http://iiif.io/api/search/1/context.json',
          '@id' => "/iiif/pch:1224/search",
          'profile' => 'http://iiif.io/api/search/1/search',
          'service' => {
            '@id' => "/iiif/pch:1224/autocomplete",
            'profile' => 'http://iiif.io/api/search/1/autocomplete'
          }
        })
      end

      context 'when there are multiple canvases' do
        let(:manifest) do
          <<~JSON
            {
              "sequences": [{
                "canvases": [{},{},{}]
              }]
            }
          JSON
        end

        it 'applies a viewingHint of "paged" to the sequence' do
          result = described_class.format(doc)
          parsed_result = JSON.parse(result)
          expect(parsed_result['sequences'][0]['viewingHint']).to eq('paged')
        end
      end

      context 'with an audio recording' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'audio' => "1_fisppzr2\n"
          }
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with an audio playlist' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'audioa' => "1_fisppzr2,1_fisppzr3,1_fisppzr4\n"
          }
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with a video recording' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'video' => "1_fisppzr2\n"
          }
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with a video playlist' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'videoa' => "1_fisppzr2,1_fisppzr3,1_fisppzr4\n"
          }
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end
    end
  end
end
