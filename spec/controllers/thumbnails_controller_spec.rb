require 'rails_helper'

describe ThumbnailsController do
  describe 'GET to #show' do
    let(:params) do
      { id: 'asdf:123', type: }
    end

    context 'when type is "Sound Recording Nonmusical"' do
      let(:type) { 'Sound Recording Nonmusical' }

      it 'redirects to the default audio URL' do
        get(:show, params:)

        expect(response).to redirect_to('/images/audio-3.png')
      end
    end

    context 'when type is "Moving Image"' do
      let(:type) { 'Moving Image' }

      it 'redirects to the default video URL' do
        get(:show, params:)

        expect(response).to redirect_to('/images/video-1.png')
      end
    end

    context 'when type is absent' do
      let(:type) { '' }

      it 'redirects to ContentDM' do
        get(:show, params:)

        expect(response).to redirect_to(
          'https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/asdf/id/123'
        )
      end
    end
  end
end
