require 'rails_helper'
require_relative '../../../lib/mdl/queue_iiif_search_processing'

module MDL
  describe QueueIiifSearchProcessing do
    describe '.format' do
      let(:document) do
        YAML.load_file(
          File.join(Rails.root, 'spec', 'fixtures', 'contentdm', filename)
        )
      end

      context 'with an audio playlist document' do
        let(:filename) { 'audio_playlist.yml' }

        it 'does not queue the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to_not receive(:perform_async)
          described_class.format(document)
        end
      end

      context 'with an audio document' do
        let(:filename) { 'audio.yml' }

        it 'does not queue the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to_not receive(:perform_async)
          described_class.format(document)
        end
      end

      context 'with an image document that has a transcription' do
        let(:filename) { 'image_with_transc.yml' }

        it 'queues the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to receive(:perform_async)
            .with('p16022coll31:14')
          QueueIiifSearchProcessing.format(document)
        end
      end

      context 'with a multi-page text document' do
        let(:filename) { 'multipage_text.yml' }

        it 'queues the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to receive(:perform_async)
            .with('nfh:806')
          QueueIiifSearchProcessing.format(document)
        end
      end

      context 'with a single-page text document' do
        let(:filename) { 'single_page_text.yml' }

        it 'queues the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to receive(:perform_async)
            .with('p16022coll73:30')
          QueueIiifSearchProcessing.format(document)
        end
      end

      context 'with a video document' do
        let(:filename) { 'video.yml' }

        it 'does not queue the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to_not receive(:perform_async)
          described_class.format(document)
        end
      end

      context 'with an video playlist document' do
        let(:filename) { 'video_playlist.yml' }

        it 'does not queue the IiifSearchProcessingWorker' do
          expect(IiifSearchProcessingWorker).to_not receive(:perform_async)
          described_class.format(document)
        end
      end
    end
  end
end
