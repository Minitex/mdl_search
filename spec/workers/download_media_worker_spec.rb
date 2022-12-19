require 'rails_helper'

describe DownloadMediaWorker do
  describe '#perform' do
    let(:worker) { DownloadMediaWorker.new }
    let(:archive_download_request) do
      ArchiveDownloadRequest.create(mdl_identifier: 'abc:123')
    end

    before do
      allow(MDL::ArchiveGenerator).to receive(:call)
        .and_return('/path/to/the/archive.zip')
      allow(ArchiveUploadWorker).to receive(:perform_async)
    end

    it 'calls the ArchiveGenerator' do
      worker.perform(archive_download_request.id)
      expect(MDL::ArchiveGenerator).to have_received(:call).with('abc:123')
    end

    it 'updates the status of the request' do
      expect { worker.perform(archive_download_request.id) }
        .to change { archive_download_request.reload.status }
        .from('requested')
        .to('generated')
    end

    it 'queues the ArchiveUploader worker' do
      worker.perform(archive_download_request.id)
      expect(ArchiveUploadWorker).to have_received(:perform_async)
        .with(archive_download_request.id, '/path/to/the/archive.zip')
    end
  end
end
