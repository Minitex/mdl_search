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
  def render_facet_partials(fields = facet_field_names, options = {})
    safe_join(facets_from_request(fields, options.delete(:response)).map do |display_facet|
      render_facet_limit(display_facet, options)
    end.compact, "\n")
  end

  def advanced_search_facets
    facets_from_request(facet_field_names).select { |f| f.items.any? }
  end

  def facets_from_request(field_names, response = nil)
    response ||= @response
    field_names.map do |field|
      response.aggregations[field]
    end
  end

  ###
  # Deprecated in Blacklight, but called by blacklight_range_limit
  def render_facet_count(num, options = {})
    classes = (options[:classes] || []) << 'facet-count'
    tag.span(
      t('blacklight.search.facets.count', number: number_with_delimiter(num)),
      class: classes
    )
  end
end
