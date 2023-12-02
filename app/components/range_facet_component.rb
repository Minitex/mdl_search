class RangeFacetComponent < BlacklightRangeLimit::RangeFacetComponent
  ###
  # Override to prevent rendering a link that opens
  # a modal containing the range limit chart
  def more_link(*)
  end

  ###
  # Override to ensure the route is targeting CatalogController. Without
  # this, route generation will fail when in the context of a Spotlight Exhibit.
  def range_limit_url(options = {})
    url_config = @facet_field.search_state.to_h.merge(
      range_field: @facet_field.key,
      action: 'range_limit',
      controller: '/catalog',
      **options
    )

    helpers.main_app.url_for(url_config)
  end
end
