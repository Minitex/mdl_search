module BlacklightAdvancedSearch
  module AdvancedSearchBuilderOverride
    def default_search_field
      blacklight_config.default_search_field
    end
  end
end

BlacklightAdvancedSearch::AdvancedSearchBuilder.prepend(
  BlacklightAdvancedSearch::AdvancedSearchBuilderOverride
)

if BlacklightAdvancedSearch::VERSION != '7.0.0'
  Rails.logger.warn <<~LOG
    An override for BlacklightAdvancedSearch::AdvancedSearchBuilder#default_search_field
    has been applied which was necessary in blacklight_advanced_search version 7.0.0.
    Since you're no longer using this version, check to see if this is still necessary.
  LOG
end
