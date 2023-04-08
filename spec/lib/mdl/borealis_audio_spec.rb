require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_audio.rb'

module MDL
  describe BorealisAudio do
    let(:instance) do
      BorealisAudio.new(
        document: { 'kaltura_audio_ssi' => 'foobar:123' }
      )
    end
    let(:playlist_instance) do
      BorealisAudio.new(
        document: { 'kaltura_audio_playlist_ssi' => 'playlist:123' }
      )
    end

    it 'provides downloads' do
      downloads = instance.downloads
      expect(downloads.size).to eq(1)
      expect(downloads[0][:label]).to eq('Download Audio')
      expect(downloads[0][:src]).to eq(
        'https://cdnapisec.kaltura.com/p/1369852/sp/136985200/playManifest/entryId/foobar:123/flavorId/1_atuqqpf6/format/url/protocol/http/a.mp4'
      )
    end

    it 'knows its type' do
      expect(instance.type).to eq 'kaltura_audio'
      expect(playlist_instance.type).to eq 'kaltura_audio_playlist'
    end

    it 'knows its audio playlist id' do
      expect(playlist_instance.audio_playlist_id).to eq 'playlist:123'
    end

    it 'knows its audio id' do
      expect(instance.audio_id).to eq 'foobar:123'
    end
  end
end

