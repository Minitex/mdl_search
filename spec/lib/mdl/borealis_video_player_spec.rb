require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_video_player.rb'
require_relative '../../../lib/mdl/borealis_video.rb'
module MDL
  describe BorealisVideoPlayer do
    describe '#to_viewer' do
      subject(:viewer_config) do
        BorealisVideoPlayer.new(assets: [video]).to_viewer
      end

      context 'when the asset type is "kaltura_video"' do
        let(:video) do
          instance_double(
            'BorealisVideo',
            type: 'kaltura_video',
            transcripts: ['A brief history of cat costumes'],
            video_id: 'v568',
            playlist_id: nil
          )
        end

        it 'produces a video configuration' do
          expect(viewer_config['type']).to eq 'kaltura_video'
          expect(viewer_config['targetId']).to eq 'kaltura_player_video'
          expect(viewer_config['wid']).to eq '_1369852'
          expect(viewer_config['uiconf_id']).to eq 38683631
          expect(viewer_config['entry_id']).to eq 'v568'
          expect(viewer_config['transcript']).to eq(
            'texts' => ['A brief history of cat costumes'],
            'label' => 'Video'
          )
          expect(viewer_config['wrapper_height']).to eq '100%'
          expect(viewer_config['wrapper_width']).to eq '100%'
          expect(viewer_config['thumbnail']).to eq '/images/video-1.png'
        end
      end

      context 'when the asset type is "kaltura_video_playlist"' do
        let(:video) do
          instance_double(
            'BorealisVideo',
            type: 'kaltura_video_playlist',
            playlist_id: 'video123',
            transcripts: ['A brief history of cat costumes'],
            video_id: 'v568'
          )
        end

        it 'produces a video playlist configuration' do
          expect(viewer_config['type']).to eq 'kaltura_video_playlist'
          expect(viewer_config['targetId']).to eq 'kaltura_player_playlist'
          expect(viewer_config['wid']).to eq '_1369852'
          expect(viewer_config['uiconf_id']).to eq 38719361
          expect(viewer_config['flashvars']).to eq(
            'streamerType' => 'auto',
            'playlistAPI.kpl0Id' => 'video123'
          )
          expect(viewer_config['transcript']).to eq(
            'texts' => ['A brief history of cat costumes'],
            'label' => 'Video Playlist'
          )
          expect(viewer_config['wrapper_height']).to eq '100%'
          expect(viewer_config['wrapper_width']).to eq '100%'
          expect(viewer_config['thumbnail']).to eq '/images/video-1.png'
        end
      end
    end
  end
end
