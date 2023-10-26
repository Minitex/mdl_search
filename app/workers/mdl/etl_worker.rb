module MDL
  class OaiRequest < CDMBL::OaiRequest
    def initialize(**kwargs)
      super(**kwargs.merge(client: OAIClient))
    end
  end

  class OAIClient
    class << self
      ###
      # Shim a read_timeout into a duck-typed HTTP client that
      # implements the interface expected by CDMBL::OaiRequest
      # (uses Net::HTTP by default). By injecting this, we can
      # handle the monstrous timeout required by CONTENTdm's
      # OAI endpoint.
      def get_response(uri)
        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == 'https',
          read_timeout: 180 # CONTENTdm's OAI endpoint can be SLOW
        ) do |http|
          request = Net::HTTP::Get.new(uri)
          http.request(request)
        end
      end
    end
  end

  class Extractor < CDMBL::Extractor
    def initialize(**kwargs)
      super(**kwargs.merge(oai_request_klass: OaiRequest))
    end
  end

  class EtlWorker < CDMBL::ETLWorker
    prepend EtlAuditing

    def initialize
      @transform_worker_klass = TransformWorker
      @extractor_klass = Extractor
      @etl_worker_klass = self.class
    end
  end
end
