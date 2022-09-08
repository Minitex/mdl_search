class FacetItemComponent < Blacklight::FacetItemComponent
  ##
  # Standard display of a facet value in a list. Used in both _facets sidebar
  # partial and catalog/facet expanded list. Will output facet value name as
  # a link to add that to your restrictions, with count in parens.
  #
  # @return [String]
  # @private
  def render_facet_value
    tag.li(class: "facet-label") do
      link_to_unless(@suppress_link, label, href, class: "facet_select #{label_class(label)}", rel: "nofollow")
    end + render_facet_count
  end

  ##
  # Standard display of a SELECTED facet value (e.g. without a link and with a remove button)
  # @see #render_facet_value
  #
  # @private
  def render_selected_facet_value
    tag.span(class: "facet-label selected #{label_class(label)}") do
      tag.span(label, class: "selected") +
        # remove link
        link_to(href, class: "remove", rel: "nofollow") do
          tag.span('✖', class: "remove-icon", aria: { hidden: true }) +
            tag.span(helpers.t(:'blacklight.search.facets.selected.remove'), class: 'sr-only visually-hidden')
        end
    end + render_facet_count(classes: ["selected"])
  end

  ##
  # Renders a count value for facet limits. Can be over-ridden locally
  # to change style. And can be called by plugins to get consistent display.
  #
  # @param [Hash] options
  # @option options [Array<String>]  an array of classes to add to count span.
  # @return [String]
  # @private
  def render_facet_count(options = {})
    return '' if hits.blank?

    classes = (options[:classes] || []) << "facet-count"
    tag.span(
      t('blacklight.search.facets.count', number: number_with_delimiter(hits)),
      class: classes
    )
  end

  private

  def label_class(label)
    case label
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
