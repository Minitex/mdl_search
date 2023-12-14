module GenerateLocalParams
  extend self

  QF = %w(
    id^180000
    title_unstem_search^160000
    title_tei^140000
    contributor_unstem_search^55000
    contributor_teim^50000
    creator_teim^50000
    creator_unstem_search^55000
    transcription_tesi^25000
    description_tei
    publishing_agency_tei
    publishing_agency_unstem_search
    topic_teim^90000
    topic_unstem_search^140000
    formal_subject_teim^100000
    formal_subject_unstem_search^150000
    subject_teim^100000
    subject_unstem_search^150000
    city_unstem_search
    district_unstem_search
    county_unstem_search
    state_unstem_search
    country_unstem_search
    language_unstem_search
    contributing_organization_tei
    contributing_unstem_search
    translation_tesi
    geographic_feature_tei
    geographic_feature_unstem_search
    image_ids_ssim
    kaltura_audio_ssi
    kaltura_audio_playlist_ssi
    kaltura_video_ssi
    local_identifier_ssi
    identifier_ssi
    identifier_ssim
    type_ssi
    type_tesi
    dat_tesi
  ).join(' ')
  private_constant :QF

  PF = %w(
    id^180000
    title_unstem_search^150000
    title_tei^100000
    contributor_unstem_search^55000
    contributor_teim^50000
    creator_teim^50000
    creator_unstem_search^55000
    description_tei
    publishing_agency_tei
    publishing_agency_unstem_search
    topic_teim
    topic_unstem_search
    formal_subject_teim^100000
    formal_subject_unstem_search^150000
    subject_teim^100000
    subject_unstem_search^150000
    city_unstem_search
    district_unstem_search
    county_unstem_search
    state_unstem_search
    country_unstem_search
    language_unstem_search
    contributing_organization_tei
    contributing_unstem_search
    transcription_tei
    geographic_feature_tei
    geographic_feature_unstem_search
    image_ids_ssim
    type_ssi
    type_tesi
    dat_tesi
  ).join(' ')
  private_constant :PF

  def call(search_builder, search_field, solr_parameters)
    res = local_params(search_builder.blacklight_params)
    "#{res}#{search_builder.blacklight_params[:q]}"
  end

  private

  def local_params(params)
    boost = params[:transcription_boost].to_i || 0
    "{!dismax qf='#{local_qf(boost)}' pf='#{local_pf(boost)}'}"
  end

  def local_qf(boost)
    boost.positive? ? "transcription_tesim^#{boost} #{QF}" : QF
  end

  def local_pf(boost)
    boost.positive? ? "transcription_tesim^#{boost} #{PF}" : PF
  end
end
