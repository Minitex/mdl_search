require 'rails_helper'

describe NotificationWorker do
  describe '#perform' do
    it 'calls the NotificationService' do
      expect(NotificationService).to receive(:notify).with('foo')
      subject.perform('foo')
    end
  end
end
