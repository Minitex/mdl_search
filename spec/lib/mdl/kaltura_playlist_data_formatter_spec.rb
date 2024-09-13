require 'rails_helper'
require_relative '../../../lib/mdl/kaltura_playlist_data_formatter'

module MDL
  describe KalturaPlaylistDataFormatter do
    describe '.format' do
      subject(:result) { described_class.format(contentdm_doc) }

      context 'with an audio playlist' do
        let(:contentdm_doc) do
          { 'audioa' => '1_h3dokqpd' }
        end

        it 'calls Kaltura to get the playlist, and the the content' do
          VCR.use_cassette('kaltura/audio_playlist', tag: :kaltura) do
            expect(JSON.parse(result, symbolize_names: true )).to eq([
              { entry_id: '1_aodbyxua', duration: 665, name: 'Interview with Vishant Shah, Part 1' },
              { entry_id: '1_880z74b6', duration: 608, name: 'Interview with Vishant Shah, Part 2' },
              { entry_id: '1_mudqx0rg', duration: 618, name: 'Interview with Vishant Shah, Part 3' },
              { entry_id: '1_umyvbja9', duration: 620, name: 'Interview with Vishant Shah, Part 4' },
              { entry_id: '1_bwmsjxa6', duration: 580, name: 'Interview with Vishant Shah, Part 5' },
              { entry_id: '1_3jccvugv', duration: 605, name: 'Interview with Vishant Shah, Part 6' },
              { entry_id: '1_c4h2sjiu', duration: 663, name: 'Interview with Vishant Shah, Part 7' },
              { entry_id: '1_zrb53lrs', duration: 617, name: 'Interview with Vishant Shah, Part 8' },
              { entry_id: '1_6vsdofcj', duration: 623, name: 'Interview with Vishant Shah, Part 9' },
              { entry_id: '1_jiw2i80w', duration: 619, name: 'Interview with Vishant Shah, Part 10' },
              { entry_id: '1_05n2aec3', duration: 577, name: 'Interview with Vishant Shah, Part 11' },
              { entry_id: '1_vmpmo06v', duration: 614, name: 'Interview with Vishant Shah, Part 12' }
            ])
          end
        end
      end

      context 'with a video playlist' do
        # Typically, video playlist IDs are also given under "audioa",
        # but there are a few documents that have this value on "videoa"
        let(:contentdm_doc) do
          {
            'audioa' => {},
            'videoa' => '0_8mpcabfz'
          }
        end

        it 'fetches the playlist from Kaltura' do
          VCR.use_cassette('kaltura/video_playlist', tag: :kaltura) do
            parsed_result = JSON.parse(result, symbolize_names: true )
            expect(parsed_result.size).to eq(2)

            expect(parsed_result[0][:entry_id]).to eq('0_2kwkz0xm')
            expect(parsed_result[0][:duration]).to eq(6415)
            expect(parsed_result[0][:name]).to match(/\AInterview with Glenn Kelley,.*Part 1\z/)

            expect(parsed_result[1][:entry_id]).to eq('0_8vwu6yp4')
            expect(parsed_result[1][:duration]).to eq(6220)
            expect(parsed_result[1][:name]).to match(/\AInterview with Glenn Kelley,.*Part 2\z/)
          end
        end
      end

      context 'with non-AV content' do
        let(:contentdm_doc) do
          { 'audioa' => nil }
        end

        it 'returns nil' do
          expect(result).to eq(nil)
        end
      end

      context 'when the playlist ID is not found in Kaltura' do
        let(:contentdm_doc) do
          { 'audioa' => 'asdfasdf' }
        end

        before do
          error = Kaltura::KalturaAPIError.new(
            'ENTRY_ID_NOT_FOUND',
            'not found message'
          )
          allow(KalturaMediaEntryService).to receive(:get)
            .and_raise(error)
        end

        it 'returns nil' do
          expect(result).to eq(nil)
        end
      end
    end
  end
end
