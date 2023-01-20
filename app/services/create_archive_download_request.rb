class CreateArchiveDownloadRequest
  # @param id [String] MDL identifier (ex. sll:24321)
  # @return [ArchiveDownloadRequest]
  def self.call(id)
    new(id).call
  end

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def call
    request = ArchiveDownloadRequest
      .not_expired
      .find_or_initialize_by(mdl_identifier: id)

    if request.new_record?
      request.save!
      DownloadMediaWorker.perform_async(request.id)
    end
    request.as_json
  end
end
