require_relative '../../../lib/mdl/borealis_asset.rb'
require_relative '../../../lib/mdl/borealis_audio.rb'

module MDL
  describe BorealisAudio do
    it 'provides downloads' do
      expect(BorealisAudio.new.downloads).to eq []
    end

    it 'knows its type' do
      expect(BorealisAudio.new.type).to eq 'kaltura_audio'
    end

    it 'knows its audio playlist id' do
      expect(BorealisAudio.new(document: { 'kaltura_audio_playlist_ssi' =>
                                           'foobar:123' })
        .audio_playlist_id).to eq 'foobar:123'
    end

    it 'knows its audio id' do
      expect(BorealisAudio.new(document: { 'kaltura_audio_ssi' =>
                                           'foobar:123' })
        .audio_id).to eq 'foobar:123'
    end
  end
end

