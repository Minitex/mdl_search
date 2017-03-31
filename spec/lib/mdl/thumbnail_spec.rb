require 'rails_helper'
require_relative '../../../lib/mdl/thumbnail.rb'

describe MDL::Thumbnail do
  let(:tmpdir) { File.join(Rails.root, 'tmp') }
  let(:tmpfilepath) { File.join(tmpdir, 'mpls_13128.jpg') }
  before(:each) do
    FileUtils.rm(tmpfilepath) if File.exist?(tmpfilepath)
  end

  subject { MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir) }

  it 'returns a default thumbnail url' do
    expect(subject.thumbnail_url).to eq 'http://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/mpls/id/13128'
  end

  it 'returns an audio thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Sound Recording Nonmusical')
    expect(thumb.thumbnail_url).to eq 'https://d1kue88aredzk1.cloudfront.net/audio-3.png'
  end

  it 'returns a video thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Moving Image')
    expect(thumb.thumbnail_url).to eq 'https://d1kue88aredzk1.cloudfront.net/video.jpg'
  end

  it 'returns its data' do
    VCR.use_cassette("thumbnail_data") do
      response = Net::HTTP.get_response(URI('http://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/mpls/id/13128')).body
      expect(subject.data).to eq response
    end
  end

  it 'correctly reports that it has not been cached when it has not been cached' do
    expect(subject.cached?).to eq false
  end

  it 'saves a thumbnail locally and lets us know if it has been saved' do
    VCR.use_cassette("save_thumbnail_data") do
      subject.save
      expect(File.exist?(tmpfilepath)).to eq true
      expect(subject.cached?).to eq true
      expect(subject.cached_file).to eq File.read(tmpfilepath)
    end
  end


end
