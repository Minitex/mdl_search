module MDLBlacklightHelper
  include Blacklight::LayoutHelperBehavior

  def current_search
    request.original_url.gsub(/\/$/, '')
  end

  def current_search_json
    current_search.gsub(/\?|catalog\/\?|catalog\?/, 'catalog.json?')
  end

  def json_result_link
    link_to(raw('<div class="icon-json float-right"><span class="sr-only">Download JSON</span></div>'), current_search_json, {class: 'json-link'})
  end

  def json_page_link
    link_to(raw('<div class="icon-json text-center"><span class="sr-only">Download JSON</span></div>'), "#{uri.scheme}://#{uri.host}:#{uri.port}/#{uri.path}.json", {class: 'json-link'})
  end

  def uri
    URI::parse(request.original_url)
  end

  def record_count(q: '*:*')
    number_with_delimiter(Blacklight.default_index.connection.get(
      'select',
      params: {
        q: q,
        defType: 'edismax',
        fl: '',
        rows: 1
      }
    )['response']['numFound'])
  end

  ##
  # Classes used for sizing the sidebar content of a Blacklight page
  # @return [String]
  def sidebar_classes
    'col-md-12 col-sm-12 col-lg-3'
  end

  def link_to_document(doc, field_or_opts = nil, opts = { counter: nil })
    case field_or_opts
    when Hash
      opts = field_or_opts
    when String
      return document_show_link(document: doc, label: field_or_opts, **opts)
    else
      field = field_or_opts
    end

    field ||= :title_tesi

    if field == :title_tesi
      field = Blacklight::Configuration::Field.new(field: field)
      label = document_presenter(doc).field_value field
    else
      label = document_presenter(doc).heading
    end

    document_show_link(document: doc, label: label, **opts)
  end

  def document_show_link(document:, label:, **opts)
    link_to(
      raw(label),
      url_for(
        controller: 'catalog',
        action: 'show',
        id: document.id,
        anchor: document_link_anchor(document)
      ),
      document_link_params(document, opts)
    )
  end

  ###
  # This provides support for "deep linking" into a specific page
  # of a compound document if the MDL identifier for that page is
  # directly queried in the global search bar.
  #
  # @param document [SolrDocument]
  # @return [String, nil]
  def document_link_anchor(document)
    cmpd_doc_page_idx = Array(document['identifier_ssim']).index(params[:q])
    return unless cmpd_doc_page_idx
    "?cv=#{cmpd_doc_page_idx}"
  end

  def document_metadata(document)
    document._source.slice(
      'id',
      'contributing_organization_ssi',
      'type_ssi',
      'collection_name_ssi'
    )
  end
end
