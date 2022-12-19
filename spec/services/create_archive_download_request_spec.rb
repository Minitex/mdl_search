require 'rails_helper'

describe CreateArchiveDownloadRequest do
  describe '.call' do
    before do
      allow(DownloadMediaWorker).to receive(:perform_async)
    end

    it 'creates an ArchiveDownloadRequest' do
      expect {
        described_class.call('otter:123')
      }.to change {
        ArchiveDownloadRequest.find_by(mdl_identifier: 'otter:123')
      }.from(nil).to(instance_of(ArchiveDownloadRequest))
    end

    it 'queues a DownloadMediaWorker' do
      expect(DownloadMediaWorker).to receive(:perform_async) do |id|
        request = ArchiveDownloadRequest.find(id)
        expect(request.mdl_identifier).to eq('otter:123')
      end
      described_class.call('otter:123')
    end

    it 'returns an attributes hash' do
      result = described_class.call('otter:123')
      expect(result).to match(hash_including(
        'id' => instance_of(Integer),
        'mdl_identifier' => 'otter:123',
        'status' => 'requested'
      ))
    end

    context 'when an in-progress request already exists' do
      let!(:existing_request) do
        ArchiveDownloadRequest.create!(
          mdl_identifier: 'otter:123',
          status: 'requested'
        )
      end

      it 'does not create a new one' do
        expect {
          described_class.call('otter:123')
        }.to_not change { ArchiveDownloadRequest.count }
      end

      it 'returns the attributes of the existing record' do
        result = described_class.call('otter:123')
        expect(result).to eq(existing_request.as_json)
      end

      it 'does not queue a DownloadMediaWorker' do
        described_class.call('otter:123')
        expect(DownloadMediaWorker).to_not have_received(:perform_async)
      end
    end
  end
end
