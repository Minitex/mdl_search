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
          FieldConfig.new(key: 'public_ssi', label: 'Expected Public Domain Entry Year'),
          FieldConfig.new(key: 'contact_information_ssi', label: 'Contact Information'),
          FieldConfig.new(key: 'collection_description_tesi', label: 'Collection Description')
        ]
      end
    end

    attr_reader :solr_doc, :auto_linker

    ###
    # @param solr_doc [SolrDocument]
    def initialize(solr_doc: '{}', auto_linker: Rinku)
      @solr_doc = solr_doc
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
      details_with_actual_collections.map do |field|
        if !redundant_rights_field?(field)
          val = solr_doc[field.key]
          vals = field_values([val].flatten, field.key, field.facet)
          map_details(vals, field.label, field.delimiter)
        end
      end.compact
    end

    private

    # @param field_config [MDL::CiteDetails::FieldConfig]
    def redundant_rights_field?(field_config)
      has_rights_uri? && field_config.key == 'rights_ssi'
    end

    def has_rights_uri?
      solr_doc.fetch('rights_uri_ssi', false) != false
    end

    # Many users add Contributing org details in the OAI collection name field.
    # We don't want to show these collections, because they are redundant with
    # contributing org. So, remove collection if these two field values are the same
    def details_with_actual_collections
      details_fields.select do |field_config|
        good_collection(field_config) || !is_collection(field_config)
      end
    end

    # @param field_config [MDL::CiteDetails::FieldConfig]
    def is_collection(field_config)
      field_config.key == 'collection_name_ssi'
    end

    # @param field_config [MDL::CiteDetails::FieldConfig]
    def good_collection(field_config)
      is_collection(field_config) && !same_contrib_and_collection?
    end

    def same_contrib_and_collection?
      solr_doc['collection_name_ssi'] == solr_doc['contributing_organization_ssi']
    end

    def map_details(values, label, delimiter = nil, facet = nil)
      if values != [{}]
        [
          {label: label},
          {delimiter: delimiter},
          {field_values: values}
        ].inject({}) do |memo, item|
          (!empty_value?(item)) ? memo.merge(item) : memo
        end
      end
    end

    def empty_value?(item)
      item.values.flatten.compact.empty?
    end

    def field_values(values, key, facet)
      values.map do |val|
        [{text: auto_link(val)}, {url: facet_url(key, val, facet)}].inject({}) do |memo, item|
          (item.values.first) ? memo.merge(item) : memo
        end
      end
    end

    # Wrap URLs in an anchor tag
    def auto_link(text)
      auto_linker.auto_link(text) if text
    end

    def facet_url(key, val, facet = false)
      if facet && val
        query = "f[#{key}][]=#{URI.encode_www_form_component(val)}"
        "/catalog?#{query}"
      end
    end

    def details_fields = self.class.field_configs
  end
end
