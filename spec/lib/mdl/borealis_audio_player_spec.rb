require_relative '../../../lib/mdl/borealis_assets_viewer.rb'
require_relative '../../../lib/mdl/borealis_audio_player.rb'
module MDL
  describe BorealisAudioPlayer do
    let(:audio) do
        instance_double("BorealisAudio",
                        collection: 'audios',
                        id: 33,
                        document: {"kaltura_audio_ssi" => "foo_bar"},
                        type: 'kaltura_audio',
                        audio_id: 'foo_bar',
                        transcripts: ["Audio One blah"])
    end

    let(:audio_playlist) do
        instance_double("BorealisAudio",
                        collection: 'audios',
                        id: 33,
                        audio_playlist_id: '123',
                        type: 'kaltura_audio',
                        audio_id: 'foo_bar',
                        transcripts: ["Audio One blah"])
    end

    it 'produces a configuration for Audios' do
      expect(audio).to receive(:audio_playlist_id)
      expect(audio).to receive(:type)
      expect(audio).to receive(:audio_id)
      expect(audio).to receive(:transcripts)
      expect(viewer(audio)).to be_kind_of(Hash)
      expect(viewer(audio)['type']).to eq 'kaltura_audio'
      expect(viewer(audio)['targetId']).to eq 'kaltura_player'
      expect(viewer(audio)['wid']).to eq '_1369852'
      expect(viewer(audio)['uiconf_id']).to eq 38708801
      expect(viewer(audio)['entry_id']).to eq 'foo_bar'
      expect(viewer(audio)['transcript']).to eq( { "texts"=>["Audio One blah"], "label"=>"Audio" })
      expect(viewer(audio)['wrapper_height']).to eq '100%'
      expect(viewer(audio)['wrapper_width']).to eq '100%'
      expect(viewer(audio)['thumbnail']).to eq '/images/audio-3.png'
    end

    it 'produces a configuration for an Audio playlist' do
      expect(audio_playlist).to receive(:audio_playlist_id)
      expect(audio_playlist).to receive(:transcripts)
      expect(viewer(audio_playlist)).to be_kind_of(Hash)
      expect(viewer(audio_playlist)['flashvars']).to eq("playlistAPI.kpl0Id" => '123', 'streamerType' => 'auto')
      expect(viewer(audio_playlist)['type']).to eq 'kaltura_audio_playlist'
      expect(viewer(audio_playlist)['targetId']).to eq 'kaltura_player_playlist'
      expect(viewer(audio_playlist)['wid']).to eq '_1369852'
      expect(viewer(audio_playlist)['uiconf_id']).to eq 38719361
      expect(viewer(audio_playlist)['transcript']).to eq( { "texts"=>["Audio One blah"], "label"=>"Audio Playlist" })
      expect(viewer(audio_playlist)['wrapper_height']).to eq '100%'
      expect(viewer(audio_playlist)['wrapper_width']).to eq '100%'
      expect(viewer(audio_playlist)['thumbnail']).to eq '/images/audio-3.png'
    end

    def viewer(asset)
      @viewer ||= BorealisAudioPlayer.new(assets: [asset]).to_viewer
    end
  end
end

