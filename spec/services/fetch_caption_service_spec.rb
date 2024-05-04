require 'rails_helper'

describe FetchCaptionService do
  around do |spec|
    VCR.use_cassette('kaltura/caption_assets') { spec.run }
  end

  context 'when there is more than one format available' do
    it 'fetches the VTT data from Kaltura' do
      captions = described_class.fetch('0_2f0zy0t1')
      expect(captions).to start_with(<<~VTT)
        1
        00:00:12,020 --> 00:00:14,110
        Okay.
      VTT
    end
  end
end
