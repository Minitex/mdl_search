module ThumbnailHelper
  def cached_thumbnail_tag(document, image_options = nil)
    collection, id = document['id'].split(':')
    thumbnail = MDL::Thumbnail.new(
      collection: collection,
      id: id,
      type: document['type_ssi']
    )
    image_tag thumbnail.url
  end

  def thumbnail_link(document)
    link_to("#{document['title_ssi'].gsub(/'/, "\\'")} <br /> #{cached_thumbnail_tag(document)}".html_safe, "/catalog/#{document['id']}")
  end

  def more_like_this_thumbnail_path(mlt_doc)
    collection, id = mlt_doc[:item_id].split(':')
    thumbnail = MDL::Thumbnail.new(
      collection: collection,
      id: id,
      type: mlt_doc[:type]
    )
    thumbnail.url
  end
end
