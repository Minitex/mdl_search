require 'kaltura'

class KalturaMediaEntryService
  class << self
    def get(id)
      new.get(id)
    end
  end

  attr_reader :client

  def initialize
    @config = Kaltura::KalturaConfiguration.new
    @client = Kaltura::KalturaClient.new(@config)
  end

  def get(id)
    params = {
      'entryId' => id,
      'version' => -1,
      'ks' => ENV['KALTURA_SESSION']
    }
    client.queue_service_action_call(
      'baseentry',
      'get',
      'KalturaBaseEntry',
      params
    )
    client.do_queue
  end
end
