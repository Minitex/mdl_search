class ArchiveUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :archive_generation

  # @param archive_download_request_id [Integer] ID of the ArchiveDownloadRequest
  # @param archive_path [String] file system path of the archive to be uploaded
  def perform(archive_download_request_id, archive_path)
    request = ArchiveDownloadRequest.find(archive_download_request_id)
    public_url = upload_archive(archive_path)
    request.update(
      status: :stored,
      storage_url: public_url,
      expires_at: 7.days.from_now
    )
    FileUtils.rm(archive_path)
  end

  private

  def upload_archive(archive_path)
    MDL::ArchiveUploader.call(archive_path)
  end
end
