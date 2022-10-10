class ArchiveDownloadRequest < ApplicationRecord
  scope :not_expired, -> {
    where('expires_at is null or expires_at > ?', Time.current)
  }
  validates :status, :mdl_identifier, presence: true
  enum status: {
    requested: 0,
    generated: 1,
    stored: 2
  }
end
