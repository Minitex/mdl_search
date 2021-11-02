require 'rails_helper'

describe IiifSearchProcessingWorker do
  describe '#perform' do
    it 'calls the ProcessDocumentForSearch' do
      expect(MDL::ProcessDocumentForSearch).to receive(:call)
        .with('my:id')

      worker = IiifSearchProcessingWorker.new
      worker.perform('my:id')
    end
  end
end
