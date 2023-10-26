require 'net/http'
require 'uri'
require 'mdl/etl_auditing'

module CDMBL
  class CompletedCallback
    def self.call!(solr_client)
      Rails.logger.info "Swapping Solr Cores Following Indexing Status: #{solr_client.inspect}"
    end
  end

  class OaiNotification
    def self.call!(location)
      Rails.logger.info "CDMBL: Requesting: #{location}"
    end
  end

  class CdmNotification
    def self.call!(collection, id, endpoint)
      Rails.logger.info "CDMBL: Requesting: #{collection}:#{id} from #{endpoint}"
    end
  end

  # An example callback
  class LoaderNotification
    def self.call!(ingestables, deletables)
      Rails.logger.info "CDMBL: Loading #{ingestables.length} records and deleting #{deletables.length}"
    end
  end

  class BatchDeletedCallback
    def self.call!(deleter)
      Rails.logger.info "CDMBL: Deleted #{deleter.deletables.size} records in batch of #{deleter.batch_size}, beginning at offset #{deleter.start}"
    end
  end

  class BatchDeleteJobCompletedCallback
    def self.call!
      Rails.logger.info "CDMBL: Batch delete job complete"
      Sentry.capture_message('Batch delete job complete')
    end
  end

  LoadWorker.prepend(MDL::EtlAuditing)
end

###
# The CONTENTdmAPI::Request constructor uses dependency injection to
# provide an http client. The default value for that is `HTTP`, which
# normally resovles to the httprb library, which is fine in practice,
# but is not compatible with WebMock which makes testing more difficult.
# Providing a namespaced HTTP constant that uses Net::HTTP under the
# hood solves that problem.
module CONTENTdmAPI
  class HTTP
    class << self
      def get(url)
        Net::HTTP.get(URI(url))
      end
    end
  end
end

###
# The CONTENTdmAPI::Request constructor uses dependency injection to
# provide an http client. The default value for that is `HTTP`, which
# normally resovles to the httprb library, which is fine in practice,
# but is not compatible with WebMock which makes testing more difficult.
# Providing a namespaced HTTP constant that uses Net::HTTP under the
# hood solves that problem.
module CONTENTdmAPI
  class HTTP
    class << self
      def get(url)
        Net::HTTP.get(URI(url))
      end
    end
  end
end
