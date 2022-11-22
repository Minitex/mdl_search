require 'rinku'

module MDL
  class CiteDetails
    attr_reader :solr_doc, :auto_linker
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
          val = solr_doc[field[:key]]
          vals = field_values([val].flatten, field[:key], field[:facet])
          map_details(vals, field[:label], field[:delimiter])
        end
      end.compact
    end

    private

    def redundant_rights_field?(field)
      has_rights_uri? && field[:key] == 'rights_ssi'
    end

    def has_rights_uri?
      solr_doc.fetch('rights_uri_ssi', false) != false
    end

    # Many users add Contributing org details in the OAI collection name field.
    # We don't want to show these collections, because they are redundant with
    # contributing org. So, remove collection if these two field values are the same
    def details_with_actual_collections()
      details_fields.select do |field|
        good_collection(field, solr_doc) || !is_collection(field)
      end
    end

    def is_collection(field)
      field[:key] == 'collection_name_ssi'
    end

    def good_collection(field, doc)
      is_collection(field) && !same_contrib_and_collection?(doc)
    end

    def same_contrib_and_collection?(doc)
      doc['collection_name_ssi'] == doc['contributing_organization_ssi']
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

    def details_fields
      [
        {key: 'contributing_organization_ssi', label: 'Contributing Organization', facet: true},
        {key: 'title_ssi', label: 'Title'},
        {key: 'creator_ssim', label: 'Creator', delimiter: ', ', facet: true},
        {key: 'contributor_ssim', label: 'Contributor', delimiter: ', ', facet: true},
        {key: 'description_ts', label: 'Description'},
        {key: 'dat_ssi', label: 'Date Created'},
        {key: 'publishing_agency_ssi', label: 'Publishing Agency', facet: true},
        {key: 'dimensions_ssi', label: 'Dimensions', facet: true},
        {key: 'topic_ssim', label: 'Minnesota Digital Library Topic', facet: true},
        {key: 'type_ssi', label: 'Type', facet: true},
        {key: 'physical_format_ssi', label: 'Physical Format', facet: true},
        {key: 'formal_subject_ssim', label: 'Library of Congress Subject Headings', facet: true},
        {key: 'subject_ssim', label: 'Keywords', facet: true},
        {key: 'city_ssim', delimiter: ', ', label: 'City or Township', facet: true},
        {key: 'county_ssim', delimiter: ', ', label: 'County', facet: true},
        {key: 'state_ssi', label: 'State or Province', facet: true},
        {key: 'country_ssi', label: 'Country', facet: true},
        {key: 'geographic_feature_ssim', label: 'Geographic Feature', facet: true},
        {key: 'geonam_ssi', label: 'GeoNames URI', facet: true},
        {key: 'language_ssi', label: 'Language'},
        {key: 'local_identifier_ssi', label: 'Local Identifier'},
        {key: 'identifier_ssi', label: 'MDL Identifier'},
        {key: 'fiscal_sponsor_ssi', label: 'Fiscal Sponsor'},
        {key: 'parent_collection_name_ssi', label: 'Collection Name', facet: true},
        {key: 'rights_ssi', label: 'Rights'},
        {key: 'rights_status_ssi', label: 'Rights'},
        {key: 'rights_statement_ssi', label: 'Rights Statement'},
        {key: 'rights_uri_ssi', label: 'Rights Statement URI'},
        {key: 'public_ssi', label: 'Expected Public Domain Entry Year'},
        {key: 'contact_information_ssi', label: 'Contact Information'},
        {key: 'collection_description_tesi', label: 'Collection Description'}
      ]
    end
  end
end
