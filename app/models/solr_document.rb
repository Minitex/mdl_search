# frozen_string_literal: true
class SolrDocument

  include Blacklight::Solr::Document

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
  use_extension( Blacklight::Document::DublinCore)



  def more_like_this
    mlt_assets solr.more_like_this(query)['response']['docs']
  end

  def solr
    SolrClient.new
  end

  def query
    "(#{mlt_values}) AND -#{self.id}"
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
      sum <<  {
                id: id,
                collection: collection,
                title: v['title_ssi'],
                type: v['type_ssi']
              }
    end
  end
end
