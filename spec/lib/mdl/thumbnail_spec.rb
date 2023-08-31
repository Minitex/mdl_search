require 'rails_helper'
require_relative '../../../lib/mdl/thumbnail.rb'

describe MDL::Thumbnail do
  it 'returns a default thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128')
    expect(thumb.thumbnail_url).to eq 'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/mpls/id/13128'
  end

  it 'returns an audio thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', type: 'Sound Recording Nonmusical')
    expect(thumb.thumbnail_url).to eq '/images/audio-3.png'
  end

  it 'returns a video thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', type: 'Moving Image')
    expect(thumb.thumbnail_url).to eq '/images/video-1.png'
  end
end
