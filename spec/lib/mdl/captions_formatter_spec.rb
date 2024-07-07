require 'rails_helper'
require_relative '../../../lib/mdl/captions_formatter'

module MDL
  describe CaptionsFormatter do
    around do |spec|
      VCR.use_cassette('kaltura/captions') { spec.run }
    end

    describe '.format' do
      context 'with a video item' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'video' => "0_2f0zy0t1\n"
          }
        end

        it 'fetches the caption data from Kaltura' do
          result = described_class.format(doc)
          expect(JSON.parse(result)['0_2f0zy0t1']).to start_with(<<~VTT)
            1
            00:00:12.020 --> 00:00:14.110
            Okay.
          VTT
        end
      end

      context 'with a video playlist' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'videoa' => '1_or91f5dp; 1_nfct7x5c; 1_0wmrqvpc; 1_ivkawv6u'
          }
        end

        it 'fetches all the caption data from Kaltura' do
          result = described_class.format(doc)
          parsed_result = JSON.parse(result)
          expect(parsed_result['1_or91f5dp']).to start_with(<<~VTT)
            1
            00:00:05.570 --> 00:00:09.255
            Hello. Today is July 30th, 1992.
          VTT
          expect(parsed_result['1_nfct7x5c']).to start_with(<<~VTT)
            1
            00:00:13.860 --> 00:00:17.950
            Okay. This time trauma.
          VTT
          expect(parsed_result['1_0wmrqvpc']).to start_with(<<~VTT)
            1
            00:00:03.320 --> 00:00:10.590
            Yeah. Yeah. Maybe a
            backup a little I guess.
          VTT
          expect(parsed_result['1_ivkawv6u']).to start_with(<<~VTT)
            1
            00:00:15.740 --> 00:00:19.560
            Okay, my final question is,
          VTT
        end
      end

      context 'with an audio item' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'audio' => "0_sihb7jhg\n"
          }
        end

        it 'fetches the caption data from Kaltura' do
          result = described_class.format(doc)
          expect(JSON.parse(result)['0_sihb7jhg']).to start_with(<<~VTT)
            1
            00:00:08.400 --> 00:00:12.100
            That'll college
            and seminary today
          VTT
        end
      end

      context 'with an audio playlist' do
        let(:doc) do
          {
            'id' => 'foo/1',
            'audioa' => '0_5rthihg2; 0_k50pdtzh'
          }
        end

        it 'fetches all the caption data from Kaltura' do
          result = described_class.format(doc)
          parsed_result = JSON.parse(result)
          expect(parsed_result['0_5rthihg2']).to start_with(<<~VTT)
            1
            00:00:06.500 --> 00:00:09.525
            Sorry. Titled his talk.
          VTT
          expect(parsed_result['0_k50pdtzh']).to start_with(<<~VTT)
            1
            00:00:04.500 --> 00:00:08.930
            I think it's time for
            us to begin today.
          VTT
        end
      end

      context 'with a non-A/V item' do
        let(:doc) do
          { 'id' => 'foo/1' }
        end

        it 'does not fetch the caption data from Kaltura' do
          expect(described_class.format(doc)).to eq(nil)
        end
      end
    end
  end
end
