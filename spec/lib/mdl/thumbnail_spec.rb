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
    expect(subject.thumbnail_url).to eq 'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/mpls/id/13128'
  end

  it 'returns an audio thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Sound Recording Nonmusical')
    expect(thumb.thumbnail_url).to eq '/images/audio-3.png'
  end

  it 'returns a video thumbnail url' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Moving Image')
    expect(thumb.thumbnail_url).to eq '/images/video-1.png'
  end

  it 'returns a filepath' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Moving Image')
    expect(thumb.file_path).to eq "#{Rails.root}/tmp/mpls_13128.jpg"
  end

  it 'returns a filename' do
    thumb = MDL::Thumbnail.new(collection:'mpls', id: '13128', cache_dir: tmpdir, type: 'Moving Image')
    expect(thumb.filename).to eq 'mpls_13128.jpg'
  end

  it 'correctly reports that it has not been cached when it has not been cached' do
    expect(subject.cached?).to eq false
  end

  it 'returns its data' do
    VCR.use_cassette("thumbnail_data") do
      response = Net::HTTP.get_response(URI('https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/mpls/id/13128')).body
      expect(subject.data).to eq response
    end
  end

  it 'saves a thumbnail locally and lets us know if it has been saved' do
    VCR.use_cassette("save_thumbnail_data") do
      subject.save
      expect(File.exist?(tmpfilepath)).to eq true
      expect(subject.cached?).to eq true
      expect(subject.cached_file).to eq File.read(tmpfilepath)
    end
  end

  describe '#url' do
    context 'when representing an audio doc (default image)' do
      subject(:instance) do
        MDL::Thumbnail.new(
          type: 'Sound Recording Nonmusical'
        ).url
      end

      it { is_expected.to eq('/images/audio-3.png') }
    end

    context 'when representing a video doc (default image)' do
      subject(:instance) do
        MDL::Thumbnail.new(
          type: 'Moving Image'
        ).url
      end

      it { is_expected.to eq('/images/video-1.png') }
    end

    context 'when representing an uncached image doc (from contentdm)' do
      subject(:instance) do
        MDL::Thumbnail.new(
          collection: 'foo',
          id: '123',
          type: 'Still Image'
        ).url
      end

      it { is_expected.to eq('/thumbnails/foo:123/Still%20Image') }
    end

    context 'when representing a cached image doc (from contentdm)' do
      subject(:instance) do
        MDL::Thumbnail.new(
          collection: 'foo',
          id: '123',
          type: 'Still Image'
        ).url
      end

      before do
        FileUtils.touch(Rails.root.join('public', 'assets', 'thumbnails', 'foo_123.jpg'))
      end

      after do
        FileUtils.rm(Rails.root.join('public', 'assets', 'thumbnails', 'foo_123.jpg'))
      end

      it { is_expected.to eq('/assets/thumbnails/foo_123.jpg') }
    end
  end
end
