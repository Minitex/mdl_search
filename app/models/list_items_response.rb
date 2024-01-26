class ListItemsResponse
  Item = Struct.new(
    :id,
    :title,
    :description,
    :collection_name
  ) do
    def as_json(*)
      {
        title:,
        description:,
        collectionName: collection_name,
        thumbnailUrl: thumbnail_url,
        catalogUrl: "https://collection.mndigital.org/catalog/#{id}"
      }
    end

    def thumbnail_url
      MDL::Thumbnail.from_identifier(id).thumbnail_url
    end
  end

  def self.from_solr(response)
    docs = Array(response.dig('response', 'docs'))
    items = docs.map do |doc|
      item = Item.new
      item.id = doc['id']
      item.title = doc['title_ssi']
      item.description = doc['description_ts']
      item.collection_name = doc['collection_name_ssi']
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
