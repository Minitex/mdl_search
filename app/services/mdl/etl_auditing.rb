module MDL
  module EtlAuditing
    JobNotYetCreatedError = Class.new(StandardError)

    module ClassMethods
      def perform_async(*args)
        jid = super
        ###
        # TODO: update CDMBL so jobs have a reference to an indexing run
        # rather than assume the last one is the one we care about. This
        # will work, though, unless we start running multiple indexing
        # runs at the same time.
        IndexingRun.last.jobs.create!(job_id: jid)
        jid
      end
    end

    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end

    def perform(*args)
      job = Job.find_by(job_id: self.jid) || job_not_found.call
      indexing_run = job.indexing_run

      super

      job.update(completed_at: Time.current)
      if indexing_finished?(indexing_run)
        SolrClient.new.commit
        notify_complete
      end
    end

    private

    def job_not_found
      if Rails.env.test?
        ###
        # Sidekiq's retry logic is off the table in the test environment,
        # and we rely on that for our Sentry notifications. So, if we're
        # in test, we'll fake it 'till we make it since we don't want to
        # notify Sentry anyway.
        proc { IndexingRun.last.jobs.create!(job_id: self.jid) }
      else
        ###
        # The job can be picked up by a worker before the Job record
        # is even created. If that happens, raise an exception to
        # trigger Sidekiq's retry logic. JobNotYetCreatedError is
        # ignored by Sentry, so it won't be noisy.
        proc { raise(JobNotYetCreatedError) }
      end
    end

    def notify_complete
      Sentry.capture_message('ETL Finished')
    end

    def indexing_finished?(indexing_run)
      indexing_run.jobs.where(completed_at: nil).none?
    end
  end
end
