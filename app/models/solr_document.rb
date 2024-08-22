# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  include Spotlight::SolrDocument

  include Spotlight::SolrDocument::AtomicUpdates
  include BlacklightOaiProvider::SolrDocument

  MDL_ITEM_URL_FIELD = 'mdl_item_url'.freeze
  private_constant :MDL_ITEM_URL_FIELD

  MDL_FIELD_SEMANTICS = {
    creator: 'creator_tesi',
    date: 'dat_ssi',
    subject: ['subject_ssim', 'keyword_tesi'],
    title: 'title_ssi',
    coverage: ['city_ssim', 'county_ssim', 'state_ssi', 'country_ssi', 'geonam_ssi'],
    language: 'language_ssi',
    format: ['physical_format_tesi', 'dimensions_ssi'],
    type: 'type_ssi',
    description: 'description_ts',
    source: 'publishing_agency_ssi',
    relation: ['topic_ssim', 'collection_name_ssi'],
    publisher: 'contributing_organization_ssi',
    rights: ['rights_ssi', 'rights_uri_ssi', 'rights_status_ssi', 'rights_statement_ssi'],
    identifier: [MDL_ITEM_URL_FIELD, 'local_identifier_ssi', 'identifier_ssi']
  }.freeze
  private_constant :MDL_FIELD_SEMANTICS

  OAI_FIELDS = (['oai_set_ssi'] + MDL_FIELD_SEMANTICS
    .values
    .flat_map(&:itself))
    .freeze

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Document::Email )

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  ###
  # These define the metadata that's returned for each record
  # when calling the OAI GetRecord verb
  field_semantics.merge!(MDL_FIELD_SEMANTICS)

  # @!attribute [r] contributing_organization
  #   @return [String]
  attribute(
    :contributing_organization,
    Blacklight::Types::String,
    'contributing_organization_ssi'
  )

  class << self
    ###
    # @param doc [Hash, SolrDocument]
    # @return SolrDocument
    def wrap(doc)
      return doc if doc.is_a?(SolrDocument)
      new(doc)
    end
  end

  ###
  # Override the default implementation here to inject a link
  # to the item into the wrapped source document. This allows
  # us to return an identifier in the OAI record response without
  # having to store it in Solr.
  def initialize(source_doc = {}, response = nil)
    item_url = "https://collection.mndigital.org/catalog/#{source_doc['id']}"
    super(
      source_doc.merge(MDL_ITEM_URL_FIELD => item_url),
      response
    )
  end

  def more_like_this
    mlt_assets solr.more_like_this(query)['response']['docs']
  end

  def solr
    SolrClient.new
  end

  def query
    "(#{mlt_values}) AND -#{self.id}"
  end

  def sets
    OaiSet.sets_for(self)
  end

  def image_url
    asset = MDL::BorealisDocument.new(document: self._source).assets.first
    return unless asset.is_a?(MDL::BorealisImage)
    asset.src
  end

  def collection_url = facet_url('contributing_organization_ssi')

  ###
  # @param property [String] a field on the document
  # @return [String] a link to search, faceted by the given property
  def facet_url(property)
    query = "f[#{property}][]=#{URI.encode_www_form_component(self[property])}"
    "/catalog?#{query}"
  end

  private

  def mlt_values
    Array.wrap([
      shorten(self['title_ssi']),
      mlt_multi_field(self['creator_ssim']),
      mlt_multi_field(self['formal_subject_teim']),
      mlt_multi_field(self['topic_teim']),
    ].reject!(&:blank?)).join(' OR ')
  end

  def shorten(value)
    Array.wrap(value.split(' ')).take(5).join(' ')
  end

  def mlt_multi_field(value)
    Array.wrap(value).join(' OR ')
  end

  def mlt_assets(mlt)
    mlt.inject([]) do |sum, v|
      collection, id = v['id'].split(':')
      sum << {
        solr_doc: v,
        id: id,
        borealis_fragment: v['borealis_fragment_ssi'],
        item_id: v['id'],
        collection: collection,
        title: v['title_ssi'],
        type: v['type_ssi']
      }
    end
  end
end
