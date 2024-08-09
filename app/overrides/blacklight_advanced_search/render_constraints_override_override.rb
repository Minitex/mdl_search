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
        filter_elements = search_state.filters.map do |field|
          # We sometimes receive params that are formatted incorrectly. For
          # instance:
          #   f[contributing_organization_ssi][0]=somevalue
          # when it should be
          #   f[contributing_organization_ssi][]=somevalue
          # This causes the values to be arrays of Hashes instead of strings
          # so this normalizes them in that situation.
          #
          # One exception is the hash { missing: true }, which Blacklight
          # defines as Blacklight::SearchState::FilterField::MISSING. This
          # is passed through as is due to its special semantic meaning to
          # the Blacklight library.
          values = field.values.flat_map do |v|
            next v if v == Blacklight::SearchState::FilterField::MISSING
            v.respond_to?(:values) ? v.values : v
          end
          render_filter_element(field.key, values, search_state)
        end

        safe_join(filter_elements, "\n")
      end
    end
  end
end

BlacklightAdvancedSearch::RenderConstraintsOverride.prepend(
  BlacklightAdvancedSearch::RenderConstraintsOverrideOverride
)
