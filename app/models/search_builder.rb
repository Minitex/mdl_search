# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  include Spotlight::AccessControlsEnforcementSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder

  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
end
