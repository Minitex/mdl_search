module FacetsHelper
  include Blacklight::FacetsHelperBehavior

  def facet_count(field)
    Blacklight.default_index.connection.get('select',
      :params => { :q => '*:*',
        :'facet.field' => field,
        :'facet.limit' => 1000,
        :defType => 'edismax',
        :fl => '',
        :rows => 1
      })['facet_counts']['facet_fields'][field].length / 2
  end

  # type is 'begin' or 'end'
  def render_empty_range_input(solr_field, type, input_label = nil, maxlength=4)
    placeholder = {
      begin: 'From (ex. 1982)',
      end: 'To (ex. 1989)'
    }[type]
    type = type.to_s

    html = label_tag("range[#{solr_field}][#{type}]", input_label, class: 'sr-only') if input_label.present?
    html ||= ''.html_safe
    html += text_field_tag("range[#{solr_field}][#{type}]", nil, maxlength: maxlength, class: "form-control range_#{type}", placeholder: placeholder)
  end

  ##
  # Render a collection of facet fields.
  # @see #render_facet_limit
  #
  # @param [Array<String>] fields
  # @param [Hash] options
  # @return String
  def render_facet_partials fields = facet_field_names, options = {}
    safe_join(facets_from_request(fields, options.delete(:response)).map do |display_facet|
      render_facet_limit(display_facet, options)
    end.compact, "\n")
  end

  def advanced_search_facets
    facets_from_request(facet_field_names).select { |f| should_render_facet?(f) }
  end

  ##
  # Standard display of a facet value in a list. Used in both _facets sidebar
  # partial and catalog/facet expanded list. Will output facet value name as
  # a link to add that to your restrictions, with count in parens.
  #
  # @param [Blacklight::Solr::Response::Facets::FacetField] facet_field
  # @param [Blacklight::Solr::Response::Facets::FacetItem] item
  # @param [Hash] options
  # @option options [Boolean] :suppress_link display the facet, but don't link to it
  # @return [String]
  def render_facet_value(facet_field, item, options ={})
    path = path_for_facet(facet_field, item)
    val = facet_display_value(facet_field, item)
    content_tag(options.fetch(:tag_name, :li), :class => "facet-label #{type_class(val)}") do
      link_to_unless(options[:suppress_link], facet_display_value(facet_field, item), path, :class=>"facet_select")
    end + render_facet_count(item.hits)
  end

    ##
  # Standard display of a SELECTED facet value (e.g. without a link and with a remove button)
  # @see #render_facet_value
  # @param [Blacklight::Solr::Response::Facets::FacetField] facet_field
  # @param [String] item
  def render_selected_facet_value(facet_field, item)
    remove_href = search_action_path(search_state.remove_facet_params(facet_field, item))
    val = facet_display_value(facet_field, item)
    content_tag(:li, class: "facet-label selected #{type_class(val)}") do
      content_tag(:span, facet_display_value(facet_field, item), class: "selected") +
      # remove link
      link_to(remove_href, class: "remove") do
        content_tag(:span, '', class: "glyphicon glyphicon-remove") +
        content_tag(:span, '[remove]', class: 'sr-only')
      end
    end + render_facet_count(item.hits, :classes => ["selected"])
  end

  def type_class(val)
    case val
    when 'Still Image'
      'icon-image'
    when 'Moving Image'
      'icon-video'
    when 'Text'
      'icon-text'
    when 'Sound Recording Nonmusical'
      'icon-sound'
    when 'Three Dimensional Object'
      'icon-object'
    when 'Notated Music'
      'icon-sheet-music'
    when 'Mixed Material'
      'icon-archive'
    when 'Cartographic'
      'icon-map'
    end
  end
end
