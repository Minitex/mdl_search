require 'rinku'

module MDL
  class CiteDetails
    class FieldConfig
      # @!attribute [r] key
      #   @return [String]
      # @!attribute [r] label
      #   @return [String]
      # @!attribute [r] facet
      #   @return [Boolean]
      # @!attribute [r] delimiter
      #   @return [String, nil]
      attr_reader :key, :label, :facet, :delimiter

      ###
      # @param key [String] Solr field name
      # @param label [String] Label for the UI
      # @param facet [Boolean] is this a facet? default false
      # @param delimiter [String] delimiter used to recognize distinct
      #   entries within multi-valued fields
      def initialize(key:, label:, facet: false, delimiter: nil)
        @key = key
        @label = label
        @facet = facet
        @delimiter = delimiter
      end
    end

    class << self
      ###
      # @return [Array<MDL::CiteDetails::FieldConfig>]
      def field_configs
        [
          FieldConfig.new(key: 'contributing_organization_ssi', label: 'Contributing Organization', facet: true),
          FieldConfig.new(key: 'title_ssi', label: 'Title'),
          FieldConfig.new(key: 'creator_ssim', label: 'Creator', delimiter: ', ', facet: true),
          FieldConfig.new(key: 'contributor_ssim', label: 'Contributor', delimiter: ', ', facet: true),
          FieldConfig.new(key: 'description_ts', label: 'Description'),
          FieldConfig.new(key: 'dat_ssi', label: 'Date Created'),
          FieldConfig.new(key: 'publishing_agency_ssi', label: 'Publishing Agency', facet: true),
          FieldConfig.new(key: 'dimensions_ssi', label: 'Dimensions', facet: true),
          FieldConfig.new(key: 'topic_ssim', label: 'Minnesota Digital Library Topic', facet: true),
          FieldConfig.new(key: 'type_ssi', label: 'Type', facet: true),
          FieldConfig.new(key: 'physical_format_ssi', label: 'Physical Format', facet: true),
          FieldConfig.new(key: 'formal_subject_ssim', label: 'Library of Congress Subject Headings', facet: true),
          FieldConfig.new(key: 'subject_ssim', label: 'Keywords', facet: true),
          FieldConfig.new(key: 'city_ssim', delimiter: ', ', label: 'City or Township', facet: true),
          FieldConfig.new(key: 'county_ssim', delimiter: ', ', label: 'County', facet: true),
          FieldConfig.new(key: 'state_ssi', label: 'State or Province', facet: true),
          FieldConfig.new(key: 'country_ssi', label: 'Country', facet: true),
          FieldConfig.new(key: 'geographic_feature_ssim', label: 'Geographic Feature', facet: true),
          FieldConfig.new(key: 'geonam_ssi', label: 'GeoNames URI'),
          FieldConfig.new(key: 'language_ssi', label: 'Language'),
          FieldConfig.new(key: 'local_identifier_ssi', label: 'Local Identifier'),
          FieldConfig.new(key: 'identifier_ssi', label: 'MDL Identifier'),
          FieldConfig.new(key: 'fiscal_sponsor_ssi', label: 'Fiscal Sponsor'),
          FieldConfig.new(key: 'parent_collection_name_ssi', label: 'Collection Name', facet: true),
          FieldConfig.new(key: 'rights_ssi', label: 'Rights'),
          FieldConfig.new(key: 'rights_status_ssi', label: 'Rights'),
          FieldConfig.new(key: 'rights_statement_ssi', label: 'Rights Statement'),
          FieldConfig.new(key: 'rights_uri_ssi', label: 'Rights Statement URI'),
          FieldConfig.new(key: 'public_ssi', label: 'Expected Public Domain Entry Year')
        ]
      end
    end

    attr_reader :solr_doc, :auto_linker

    ###
    # @param solr_doc [SolrDocument]
    def initialize(solr_doc:, auto_linker: Rinku)
      @solr_doc = SolrDocument.wrap(solr_doc)
      @auto_linker = auto_linker
    end

    def to_hash
      {
        focus: true,
        type: 'details',
        label: 'Details',
        fields: details
      }
    end

    def details
      self.class.field_configs.filter_map do |field_config|
        next if redundant_rights_field?(field_config)

        val = solr_doc[field_config.key]
        vals = field_values([val].flatten, field_config)
        map_details(vals, field_config)
      end
    end

    private

    # @param field_config [MDL::CiteDetails::FieldConfig]
    def redundant_rights_field?(field_config)
      has_rights_uri? && field_config.key == 'rights_ssi'
    end

    def has_rights_uri?
      !!solr_doc.fetch('rights_uri_ssi', false)
    end

    def field_values(values, field_config)
      values.filter_map do |val|
        {
          text: auto_link(val),
          url: url(val, field_config)
        }.compact.presence
      end
    end

    # Wrap URLs in an anchor tag
    def auto_link(text)
      auto_linker.auto_link(text) if text
    end

    def url(val, field_config)
      custom = custom_url(field_config.key, val)
      return custom if custom

      if field_config.facet && val
        query = "f[#{field_config.key}][]=#{URI.encode_www_form_component(val)}"
        "/catalog?#{query}"
      end
    end

    ###
    # This is barebones for now, but leaves the door open to
    # offering custom links on other Solr fields.
    #
    # @param key [String] A Solr document key
    # @param val [String] the value in the document for the given key
    # @return [String, nil] A custom URL, if applicable
    def custom_url(key, val)
      case key
      when 'contributing_organization_ssi'
        ContributingOrganizationLink.resolve(val)
      end
    end

    def map_details(field_values, facet_config)
      return if field_values.empty?

      {
        label: facet_config.label,
        delimiter: facet_config.delimiter,
        field_values:
      }.compact
    end
  end
end
