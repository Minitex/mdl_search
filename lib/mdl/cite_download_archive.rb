module MDL
  class CiteDownloadArchive
    def initialize(ready_url:, download_request_url:, item_id:)
      @ready_url = ready_url
      @download_request_url = download_request_url
      @item_id = item_id
    end

    def to_hash
      {
        focus: false,
        type: 'archive',
        label: 'Download All',
        downloadRequestUrl: @download_request_url,
        itemId: @item_id,
        readyUrl: @ready_url
      }
    end
  end
end
