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
          expect(described_class.format(doc)).to start_with(<<~VTT)
            1
            00:00:12,020 --> 00:00:14,110
            Okay.
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
          expect(described_class.format(doc)).to start_with(<<~VTT)
            1
            00:00:08,400 --> 00:00:12,100
            That'll college
            and seminary today
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
