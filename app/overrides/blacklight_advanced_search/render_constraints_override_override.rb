module BlacklightAdvancedSearch
  module RenderConstraintsOverrideOverride
    ##
    # Render the facet constraints
    # This is the original Blacklight implementation, which is overridden by
    # BlacklightAdvancedSearch. The override doesn't work for our purposes,
    # because it ends up duplicating the facets in the constraints panel
    # of the search results page.
    #
    # @deprecated
    # @param [Blacklight::SearchState,Hash] params_or_search_state query parameters
    # @return [String]
    def render_constraints_filters(params_or_search_state = search_state)
      Deprecation.warn(Blacklight::RenderConstraintsHelperBehavior, 'render_constraints_filters is deprecated')
      search_state = convert_to_search_state(params_or_search_state)

      return "".html_safe unless search_state.filters.any?

      Deprecation.silence(Blacklight::RenderConstraintsHelperBehavior) do
        safe_join(search_state.filters.map do |field|
          render_filter_element(field.key, field.values, search_state)
        end, "\n")
      end
    end
  end
end

BlacklightAdvancedSearch::RenderConstraintsOverride.prepend(
  BlacklightAdvancedSearch::RenderConstraintsOverrideOverride
)
