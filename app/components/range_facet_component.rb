class RangeFacetComponent < BlacklightRangeLimit::RangeFacetComponent
  ###
  # Override to prevent rendering a link that opens
  # a modal containing the range limit chart
  def more_link(*)
  end
end
