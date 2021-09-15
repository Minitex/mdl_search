require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_video.rb'
require_relative '../../../lib/mdl/borealis_video_player.rb'
module MDL
  describe BorealisVideo do
    let(:document) do
      { 'kaltura_video_ssi' => '1234' }
    end
    subject(:video) do
      BorealisVideo.new(
        document: document,
        collection: 'foo',
        id: '124'
      )
    end

    it 'provides a download link' do
      expect(video.downloads).to eq []
    end

    it 'knows its src' do
      expect(video.src).to eq 'http://cdm16022.contentdm.oclc.org/utils/getstream/collection/foo/id/124'
    end

    it 'knows its player' do
      expect(video.viewer).to be MDL::BorealisVideoPlayer
    end

    it 'knows its video_id' do
      expect(video.video_id).to eq '1234'
    end

    describe '#playlist_id' do
      context 'when the document has a video playlist ID' do
        let(:document) do
          super().merge('kaltura_video_playlist_ssi' => 'video123')
        end

        it 'returns the video playlist ID' do
          expect(video.playlist_id).to eq('video123')
        end
      end

      context 'when the document has an audio playlist ID' do
        let(:document) do
          super().merge('kaltura_audio_playlist_ssi' => 'audio123')
        end

        it 'returns the audio playlist ID' do
          expect(video.playlist_id).to eq('audio123')
        end
      end

      context 'when the document has both video and audio playlist IDs' do
        let(:document) do
          super().merge(
            'kaltura_video_playlist_ssi' => 'video123',
            'kaltura_audio_playlist_ssi' => 'audio123'
          )
        end

        it 'returns the video playlist ID' do
          expect(video.playlist_id).to eq('video123')
        end
      end
    end

    describe '#type' do
      context 'when it has a playlist_id' do
        let(:document) do
          super().merge('kaltura_video_playlist_ssi' => 'video123')
        end

        it 'returns "kaltura_video_playlist"' do
          expect(video.type).to eq 'kaltura_video_playlist'
        end
      end

      context 'when it does not have a playlist_id' do
        it 'returns "kaltura_video"' do
          expect(video.type).to eq 'kaltura_video'
        end
      end
    end
  end
end
