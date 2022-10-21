require 'rails_helper'

describe 'requesting an archive download' do
  let(:headers) do
    { 'Accept' => 'application/json' }
  end

  describe 'creating the request' do
    before do
      allow(DownloadMediaWorker).to receive(:perform_async)
    end

    it 'creates an ArchiveDownloadRequest' do
      solr_fixtures('otter:297')
      params = { id: 'otter:297' }
      expect {
        post '/archive_download_requests', params: params, headers: headers
      }.to change(ArchiveDownloadRequest, :count).by(1)
      expect(response.status).to eq(201)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['status']).to eq('requested')
      expect(parsed_response['mdl_identifier']).to eq('otter:297')
      expect(parsed_response['id']).to be_present

      expect(response.headers['Location']).to eq(
        "/archive_download_requests/#{parsed_response['id']}"
      )

      expect(DownloadMediaWorker).to have_received(:perform_async)
        .with(parsed_response['id'])
    end

    context 'when there is no document for the given ID' do
      it 'returns 422' do
        params = { id: 'fiat:123' }
        expect {
          post '/archive_download_requests', params: params, headers: headers
        }.to_not change(ArchiveDownloadRequest, :count)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'getting request details' do
    let(:download_request) do
      ArchiveDownloadRequest.create(
        mdl_identifier: 'owl:123',
        status: 'generated',
        storage_url: 'https://somewhere-over-the-rain.bow'
      )
    end

    it 'returns the request details' do
      get archive_download_request_path(download_request), headers: headers
      expect(response.status).to eq(200)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['id']).to eq(download_request.id)
      expect(parsed_response['mdl_identifier']).to eq('owl:123')
      expect(parsed_response['status']).to eq('generated')
      expect(parsed_response['storage_url']).to eq('https://somewhere-over-the-rain.bow')
    end

    it 'returns useful not found response' do
      get archive_download_request_path(1), headers: headers
      expect(response.status).to eq(404)
      expect(response.body).to eq('{"error":"not found"}')
    end
  end

  describe 'checking if a download is ready' do
    let(:create_request) do
      ArchiveDownloadRequest.create(
        mdl_identifier: 'owl:123',
        status: status,
        storage_url: 'https://somewhere-over-the-rain.bow'
      )
    end

    before do
      create_request
      get ready_archive_download_request_path('owl:123'), headers: headers
    end

    context 'when yes' do
      let(:status) { 'stored' }

      it 'returns the request details' do
        expect(response.status).to eq(200)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['id']).to eq(create_request.id)
        expect(parsed_response['mdl_identifier']).to eq('owl:123')
        expect(parsed_response['status']).to eq('stored')
        expect(parsed_response['storage_url']).to eq('https://somewhere-over-the-rain.bow')
      end
    end

    context 'when not quite yet' do
      let(:status) { 'requested' }

      it 'returns 404' do
        expect(response.status).to eq(404)
      end
    end

    context 'when no' do
      let(:create_request) { nil }

      it 'returns 404' do
        expect(response.status).to eq(404)
      end
    end
  end
end
