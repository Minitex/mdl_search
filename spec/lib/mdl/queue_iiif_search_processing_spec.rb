require 'rails_helper'
require_relative '../../../lib/mdl/queue_iiif_search_processing'

module MDL
  describe QueueIiifSearchProcessing do
    describe '.format' do
      context 'when the primary document has a transcription' do
        let(:document) do
          {
            'id' => 'pch/1224',
            'transc' => 'foo'
          }
        end

        it 'queues the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to receive(:perform_async)
            .with('pch:1224')
          QueueIiifSearchProcessing.format(document)
        end
      end

      context 'when the primary document does not have a transcription' do
        let(:document) do
          { 'id' => 'abc/123' }
        end

        it 'does not queue the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to_not receive(:perform_async)
          QueueIiifSearchProcessing.format(document)
        end

        context 'but one of the sub-pages has a transcription' do
          let(:document) do
            {
              'id' => 'pch/1224',
              'page' => [{ 'transc' => 'foo' }]
            }
          end
          it 'queues the IiifSearchProcessingWorker' do
            expect(IiifSearchProcessingWorker).to receive(:perform_async)
              .with('pch:1224')
            QueueIiifSearchProcessing.format(document)
          end
        end
      end
    end
  end
end
