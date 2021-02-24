# frozen_string_literal: true

require_relative './multi_date_formatter'

module MDL
  # CDMBL field mappings
  class Transformer
    class RemoveHashFormatter
      def self.format(values)
        values unless values.is_a?(Hash)
      end
    end

    # Calculating the Borealis fragment is expensive, so it is precalculated
    # here
    class BorealisFragmentFormatter
      def self.format(doc)
        # This is pretty ugly. OK, it's heinous. I am not going to refactor the
        # Borealis code though, b/c my plan is to migrate MDL to the new UMedia
        # platform and get rid of React altogether...partially b/c we can get
        # rid of a lot of this ugly config generation code
        if (!doc.fetch('format').is_a?(Hash))
          doc = doc.merge('format_tesi' => doc.fetch('format'))
        end
        compounds = ((doc['page'].is_a?(Hash)) ? [] : doc['page']).to_json
        doc = doc.merge('compound_objects_ts' => compounds)
        MDL::DocumentAnchor.new(doc: doc).anchor
      end
    end

    def self.field_mappings
      [
        {dest_path: 'location_llsi', origin_path: '/', formatters: [CDMBL::LocationFormatter]},
        {dest_path: 'id', origin_path: 'id', formatters: [CDMBL::StripFormatter, CDMBL::IDFormatter]},
        {dest_path: 'setspec_ssi', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::SetSpecFormatter]},
        {dest_path: 'collection_name_ssi', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::CollectionNameFormatter]},
        {dest_path: 'collection_name_tei', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::CollectionNameFormatter]},
        {dest_path: 'collection_description_tesi', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::CollectionDescriptionFormatter, CDMBL::FilterBadCollections]},
        {dest_path: 'parent_collection_name_ssi', origin_path: 'par', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'parent_collection_name_tei', origin_path: 'par', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'parent_collection_description_tei', origin_path: 'par', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_tesi', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_ssi', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_sort', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_unstem_search', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributor_teim', origin_path: 'contri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributor_unstem_search', origin_path: 'contri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributor_ssim', origin_path: 'contri', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'creator_tesi', origin_path: 'photog', formatters: [CDMBL::JoinFormatter, CDMBL::StripFormatter]},
        {dest_path: 'creator_unstem_search', origin_path: 'photog', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'creator_ssim', origin_path: 'photog', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'creator_sort', origin_path: 'photog', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'description_tei', origin_path: 'descri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'description_ts', origin_path: 'descri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dat_ssi', origin_path: 'dat', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dat_ssim', origin_path: 'dat', formatters: [MDL::MultiDateFormatter]},
        {dest_path: 'dat_tesi', origin_path: 'dat', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dat_sort', origin_path: 'dat', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'publishing_agency_tei', origin_path: 'publia', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'publishing_agency_unstem_search', origin_path: 'publia', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'publishing_agency_ssi', origin_path: 'publia', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dimensions_ssi', origin_path: 'dimens', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'topic_teim', origin_path: 'genera', formatters: [CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'topic_ssim', origin_path: 'genera', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'topic_unstem_search', origin_path: 'genera', formatters: [CDMBL::StripSemicolonFormatter, CDMBL::StripFormatter]},
        {dest_path: 'type_ssi', origin_path: 'type', formatters: [CDMBL::Titlieze, CDMBL::StripSemicolonFormatter, CDMBL::StripFormatter]},
        {dest_path: 'type_tesi', origin_path: 'type', formatters: [CDMBL::Titlieze, CDMBL::StripSemicolonFormatter, CDMBL::StripFormatter]},
        {dest_path: 'physical_format_ssi', origin_path: 'physic', formatters: [CDMBL::StripSemicolonFormatter]},
        {dest_path: 'physical_format_tesi', origin_path: 'physic', formatters: [CDMBL::StripSemicolonFormatter]},
        {dest_path: 'formal_subject_unstem_search', origin_path: 'specif', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'formal_subject_ssim', origin_path: 'specif', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'formal_subject_teim', origin_path: 'specif', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'subject_unstem_search', origin_path: 'subjec', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'subject_teim', origin_path: 'subjec', formatters: [CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'subject_ssim', origin_path: 'subjec', formatters: [CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'keyword_unstem_search', origin_path: '/', formatters: [CDMBL::KeywordFormatter, CDMBL::Titlieze, CDMBL::UniqueFormatter, CDMBL::StripFormatter]},
        {dest_path: 'keyword_tesi', origin_path: '/', formatters: [CDMBL::KeywordFormatter, CDMBL::Titlieze, CDMBL::UniqueFormatter, CDMBL::JoinFormatter, CDMBL::StripFormatter]},
        {dest_path: 'keyword_ssim', origin_path: '/', formatters: [CDMBL::KeywordFormatter, CDMBL::Titlieze, CDMBL::UniqueFormatter, CDMBL::StripFormatter]},
        {dest_path: 'city_ssim', origin_path: 'city', formatters: [CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'city_unstem_search', origin_path: 'city', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'district_ssi', origin_path: 'distri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'district_unstem_search', origin_path: 'distri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'county_ssim', origin_path: 'county', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'county_unstem_search', origin_path: 'county', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'state_ssi', origin_path: 'state', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'state_unstem_search', origin_path: 'state', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'country_ssi', origin_path: 'countr', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'country_unstem_search', origin_path: 'countr', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'language_ssi', origin_path: 'langua', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'language_unstem_search', origin_path: 'langua', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributing_unstem_search', origin_path: 'contra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributing_organization_tesi', origin_path: 'contra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributing_organization_ssi', origin_path: 'contra', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter]},
        {dest_path: 'contact_information_ssi', origin_path: 'contac', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'rights_ssi', origin_path: 'righta', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'local_identifier_ssi', origin_path: 'identi', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'identifier_ssi', origin_path: 'resour', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'project_ssi', origin_path: 'projec', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'fiscal_sponsor_ssi', origin_path: 'fiscal', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'publisher_ssi', origin_path: 'publis', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'date_ssi', origin_path: 'date', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'format_tesi', origin_path: 'format', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'digspa_ssi', origin_path: 'digspa'},
        {dest_path: 'digspb_ssi', origin_path: 'digspb'},
        {dest_path: 'digspc_ssi', origin_path: 'digspc'},
        {dest_path: 'digspd_ssi', origin_path: 'digspd'},
        {dest_path: 'digspe_ssi', origin_path: 'digspe'},
        {dest_path: 'digspf_ssi', origin_path: 'digspf'},
        {dest_path: 'digspg_ssi', origin_path: 'digspg'},
        {dest_path: 'digsph_ssi', origin_path: 'digsph'},
        {dest_path: 'digspi_ssi', origin_path: 'digspi'},
        {dest_path: 'digspj_ssi', origin_path: 'digspj'},
        {dest_path: 'digspk_ssi', origin_path: 'digspk'},
        {dest_path: 'transcription_tesi', origin_path: 'transc', formatters: [RemoveHashFormatter, CDMBL::StripFormatter]},
        {dest_path: 'translation_tesi', origin_path: 'transl', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'fullrs_tesi', origin_path: 'fullrs', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'find_ssi', origin_path: 'find', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dmaccess_ssi', origin_path: 'dmaccess', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dmimage_ssi', origin_path: 'dmimage', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dmcreated_ssi', origin_path: 'dmcreated', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dmmodified_ssi', origin_path: 'dmmodified', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dmoclcno_ssi', origin_path: 'dmoclcno', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'restriction_code_ssi', origin_path: 'restrictionCode', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'cdmfilesize_ssi', origin_path: 'cdmfilesize', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'cdmfilesizeformatted_ssi', origin_path: 'cdmfilesizeformatted', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'cdmprintpdf_is', origin_path: 'cdmprintpdf', formatters: [CDMBL::ToIFormatter]},
        {dest_path: 'cdmhasocr_is', origin_path: 'cdmhasocr', formatters: [CDMBL::ToIFormatter]},
        {dest_path: 'cdmisnewspaper_is', origin_path: 'cdmisnewspaper', formatters: [CDMBL::ToIFormatter]},
        {dest_path: 'image_uri_ssi', origin_path: 'image_uri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'record_type_ssi', origin_path: 'record_type', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'geographic_feature_ssim', origin_path: 'geogra', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'geographic_feature_teim', origin_path: 'geogra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'geographic_feature_unstem_search', origin_path: 'geogra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'compound_objects_ts', origin_path: 'page', formatters: [CDMBL::ToJsonFormatter]},
        {dest_path: 'geonam_ssi', origin_path: 'geonam', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_audio_ssi', origin_path: 'audio', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_audio_playlist_ssi', origin_path: 'audioa', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_video_ssi', origin_path: 'video', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_video_playlist_ssi', origin_path: 'videoa', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'coordinates_llsi', origin_path: 'geonam', formatters: [CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToLocation]},
        {dest_path: 'placename_ssim', origin_path: 'geonam', formatters: [CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToPlaceName]},
        {dest_path: 'placename_unstem_search', origin_path: 'geonam', formatters: [CDMBL::GeoNameID, CDMBL::GeoNameIDToJson, CDMBL::GeoNameToPlaceName]},
        {dest_path: 'table_ssim', origin_path: 'table', formatters: [CDMBL::StripFormatter, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'umedia_ssi', origin_path: 'umedia', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'rights_uri_ssi', origin_path: 'rights', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'rights_status_ssi', origin_path: 'rightc', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'rights_statement_ssi', origin_path: 'rightd', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'public_ssi', origin_path: 'public', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'borealis_fragment_ssi', origin_path: '/', formatters: [BorealisFragmentFormatter]}
      ]
    end
  end
end
