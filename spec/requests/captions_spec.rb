require 'rails_helper'

describe 'fetching captions for A/V items' do
  let(:captions) { <<~VTT }
    WEBVTT

    1
    00:00:00.720 --> 00:00:05.680
    All right. It's
    February 19, 2019,

    2
    00:00:05.680 --> 00:00:07.600
    and I'm at the Continuing Legal

    3
    00:00:07.600 --> 00:00:10.320
    Education Center
    in Minneapolis to

    4
    00:00:10.320 --> 00:00:12.040
    Interview Retired
    Minnesota Supreme

    5
    00:00:12.040 --> 00:00:13.660
    Court Justice Allen Page
  VTT

  before { solr_fixtures('sll:22548') }

  it 'returns the captions' do
    get "/tracks/sll:22548/entry/1_fisppzr2.vtt"
    expect(response.body).to start_with(captions)
  end
end
