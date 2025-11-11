class ListItemsResponse
  Item = Struct.new(
    :id,
    :title,
    :description,
    :collection_name,
    :catalog_path,
    :thumbnail_url
  ) do
    def as_json(*)
      {
        id:,
        title:,
        description:,
        collectionName: collection_name,
        catalogUrl: "#{catalog_path}/#{id}",
        thumbnailUrl: thumbnail_url
      }
    end
  end

  ###
  # @param response [Hash] the parsed Solr response body JSON
  # @param catalog_path [String] the base URL to the catalog resource
  # @return [ListItemsResponse]
  def self.from_solr(response, catalog_path:)
    docs = Array(response.dig('response', 'docs'))
    items = docs.map do |doc|
      thumbnail = MDL::Thumbnail.from_solr_doc(doc)

      item = Item.new
      item.id = doc['id']
      item.title = doc['title_ssi']
      item.description = doc['description_ts']
      item.collection_name = doc['collection_name_ssi']
      item.catalog_path = catalog_path
      item.thumbnail_url = thumbnail.url
      item
    end
    new(items)
  end

  def initialize(items)
    @items = items
  end

  def as_json(*)
    {
      items: @items.map(&:as_json),
      count: @items.count
    }
  end
end
