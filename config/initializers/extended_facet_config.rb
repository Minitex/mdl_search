Rails.application.config.after_initialize do
  ###
  # Extend the available facets by which a user can filter
  # search results. CatalogController itself configures several
  # facet fields, but these extended facets exist to support
  # faceting on the various components of CiteDetails. We're
  # configuring them separately because we don't want to render
  # facet panels for them on the search results page, but
  # Blacklight requires configured facet fields in order to issue
  # the correct Solr query.
  #
  # @see MDL::CiteDetails::field_configs
  CatalogController.blacklight_config.configure do |config|
    MDL::CiteDetails.field_configs.each do |field_config|
      # Skip non-facet fields
      next unless field_config.facet

      # Skip the field if CatalogController has already configured it
      next if config.facet_fields.key?(field_config.key)

      config.add_facet_field(field_config.key) do |field|
        field.label = field_config.label
        field.show = false
      end
    end
  end
end
