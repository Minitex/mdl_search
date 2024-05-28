require 'kaltura'

class FetchCaptionService
  ###
  # @param entry_id [String]
  # @return [String] VTT text
  def self.fetch(entry_id)
    service = new
    response = service.list_caption_assets(entry_id)
    caption_asset = Array(response.objects)
      .lazy
      .select { |o| o.file_ext == 'srt' }
      .sort_by { |o| -o.accuracy }
      .first || return
    service.fetch(caption_asset.id)
  end

  def initialize
    config = Kaltura::KalturaConfiguration.new
    @client = Kaltura::KalturaClient.new(config)
  end

  def list_caption_assets(entry_id)
    kparams = {
      'filter' => {
        'entryIdEqual' => entry_id,
        'objectType' => 'KalturaAssetFilter'
      },
      'ks' => ENV['KALTURA_SESSION']
    }
    client.queue_service_action_call(
      'caption_captionasset',
      'list',
      'KalturaCaptionAssetListResponse',
      kparams
    )
    client.do_queue
  end

  ###
  # @param caption_asset_id [String]
  # @return [String] VTT-formatted text
  def fetch(caption_asset_id)
    kparams = {
      'captionAssetId' => caption_asset_id,
      'ks' => ENV['KALTURA_SESSION']
    }
    client.queue_service_action_call(
      'caption_captionasset',
      'serve',
      'file',
      kparams
    )
    url = client.get_serve_url
    Net::HTTP.get(URI(url))
  end

  private

  attr_reader :client
end
