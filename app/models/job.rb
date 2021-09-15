class Job < ActiveRecord::Base
  belongs_to :indexing_run
  validates :job_id, presence: true
end
