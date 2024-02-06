class DownloadMediaWorker
  include Sidekiq::Worker
  sidekiq_options queue: :archive_generation

  # @param archive_download_request_id [Integer] ID of the ArchiveDownloadRequest
  def perform(archive_download_request_id)
    request = ArchiveDownloadRequest.find(archive_download_request_id)
    archive_path = generate_archive(request)
    request.generated!
    queue_upload(request, archive_path)
  end

  private

  def generate_archive(request)
    MDL::ArchiveGenerator.call(request.mdl_identifier)
  end

  def queue_upload(request, archive_path)
    ArchiveUploadWorker.perform_async(request.id, archive_path)
  end
end
