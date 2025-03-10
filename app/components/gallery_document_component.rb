class GalleryDocumentComponent < Blacklight::Gallery::DocumentComponent
  def thumbnail_link
    helpers.document_show_link(
      document: @document,
      label: helpers.thumbnail_tag(@document),
      counter: @counter
    )
  end

  def title_link
    helpers.link_to_document(
      @document,
      helpers.document_show_link_field(@document),
      counter: @counter
    )
  end

  def document_actions
    helpers.render_index_doc_actions(
      @document,
      wrapping_class: "index-document-functions col-sm-3 col-lg-2"
    )
  end
end
