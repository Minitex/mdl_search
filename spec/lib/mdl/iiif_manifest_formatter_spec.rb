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
        FactoryBot.build(:cdm_document, :image)
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
          '@id' => "/iiif/p16022coll31:14/search",
          'profile' => 'http://iiif.io/api/search/1/search',
          'service' => {
            '@id' => "/iiif/p16022coll31:14/autocomplete",
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
      end

      context 'with a multi-page document' do
        let(:manifest) { FactoryBot.build(:cdm_iiif_manifest) }
        let(:doc) do
          FactoryBot.build(:cdm_document, fixture: 'multipage_text_mhd:6801.yml')
        end

        it 'applies page-level metadata to each canvas' do
          result = described_class.format(doc)
          parsed_result = JSON.parse(result)
          canvases = parsed_result.dig('sequences', 0, 'canvases')
          metadata = canvases[0]['metadata']
          expect(metadata[0]['label']).to eq('Title')
          expect(metadata[0]['value'])
            .to eq('Edgar F. Comstock letter, June 14, 1890, page 1')

          # TODO: add assertions for the other metadata elements

          expect(canvases).to all satisfy('have metadata') { |c|
            c.key?('metadata') && c['metadata'].size > 1
          }
        end
      end

      context 'with an audio recording' do
        let(:doc) do
          FactoryBot.build(:cdm_document, :audio)
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with an audio playlist' do
        let(:doc) do
          FactoryBot.build(:cdm_document, :audio_playlist)
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with a video recording' do
        let(:doc) do
          FactoryBot.build(:cdm_document, :video)
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end

      context 'with a video playlist' do
        let(:doc) do
          FactoryBot.build(:cdm_document, :video_playlist)
        end

        it 'returns nil' do
          expect(described_class.format(doc)).to be_nil
        end
      end
    end
  end
end
