require 'rails_helper'

describe ArchiveUploadWorker do
  describe '#perform' do
    let(:request) do
      ArchiveDownloadRequest.create(
        mdl_identifier: 'abc:123',
        status: 'generated'
      )
    end
    let(:worker) { ArchiveUploadWorker.new }

    before do
      allow(MDL::ArchiveUploader).to receive(:call)
        .and_return('http://downloadurl.zip')
      allow(FileUtils).to receive(:rm).with('/path/to/the/archive.zip')
    end

    it 'uploads the archive then deletes the local copy' do
      worker.perform(request.id, '/path/to/the/archive.zip')
      expect(MDL::ArchiveUploader).to have_received(:call)
        .with('/path/to/the/archive.zip')
      expect(FileUtils).to have_received(:rm)
        .with('/path/to/the/archive.zip')
    end

    it 'updates the request' do
      expect { worker.perform(request.id, '/path/to/the/archive.zip') }
        .to change { request.reload.status }
        .from('generated').to('stored')
        .and change { request.reload.storage_url }
        .from(nil).to('http://downloadurl.zip')
        .and change { request.reload.expires_at }
        .from(nil).to(instance_of(ActiveSupport::TimeWithZone))
    end
  end
end
