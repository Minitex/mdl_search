require 'rails_helper'

describe 'fetching captions for A/V items' do
  let(:entry_id) { 'someEntryId' }
  let(:captions) { <<~VTT }
    1
    00:00:12,020 --> 00:00:14,110
    Okay.

    2
    00:00:19,220 --> 00:00:21,430
    Right.

    3
    00:01:12,550 --> 00:01:14,885
    You want to go to copycat?
  VTT

  before do
    allow(FetchCaptionService)
      .to receive(:fetch)
      .with(entry_id)
      .and_return(captions)
  end

  it 'returns the captions' do
    get "/tracks/#{entry_id}.vtt"
    expect(response.body).to eq(captions)
  end
end
