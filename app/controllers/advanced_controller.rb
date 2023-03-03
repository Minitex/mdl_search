class AdvancedController < BlacklightAdvancedSearch::AdvancedController
  include BlacklightRangeLimit::ControllerOverride

  def index
    if params == {"controller"=>"advanced", "action"=>"index"}
      @response = Rails.cache.fetch("advanced_search", expires_in: 12.hours) do
        get_advanced_search_facets unless request.method == :post
      end
    else
      @response = get_advanced_search_facets unless request.method == :post
    end
  end

  blacklight_config.configure do |config|
    # name of Solr request handler, leave unset to use the same one your Blacklight
    # is ordinarily using (recommended if possible)
    # config.advanced_search.qt = 'advanced'

    ##
    # The advanced search form displays facets as a limit option.
    # By default it will use whatever facets, if any, are returned
    # by the Solr request handler in use. However, you can use
    # this config option to have it request other facet params than
    # default in the Solr request handler, in desired.
    config.advanced_search.form_solr_parameters = {}

    # name of key in Blacklight URL, no reason to change usually.
    config.advanced_search.url_key = 'advanced'
    config.advanced_search.form_facet_partial = 'advanced_search_facets_as_select'

    # We are going to completely override the inherited search fields
    config.search_fields.clear
    config.add_search_field 'all_fields', label: 'All Fields'
    config.add_search_field('title') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
      field.solr_local_parameters = {
        qf: '$title_qf',
        pf: '$title_pf'
      }
    end
    config.add_search_field('creator') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'creator' }
      field.solr_local_parameters = {
        qf: '$creator_qf',
        pf: '$creator_pf'
      }
    end
    config.add_search_field('description') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$description_qf',
        pf: '$description_pf'
      }
    end
    config.add_search_field('city_or_township') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$city_or_township_qf',
        pf: '$city_or_township_pf'
      }
    end
    config.add_search_field('county') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$county_qf',
        pf: '$county_pf'
      }
    end
    config.add_search_field('transcript') do |field|
      ###
      # Temporarily excluded from advanced search. Remove
      # next line to re-enable the transcript search input
      field.include_in_advanced_search = false
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$transcription_qf',
        pf: '$transcription_pf'
      }
    end

    ###
    # Define facets specifically for advanced search. These are only
    # slightly different from the ones defined in CatalogController.
    # They're collapsed, and have (or can have) different limits set
    # so that more facet options are available on the advanced search
    # form.
    config.facet_fields.clear
    config.add_facet_field 'topic_ssim' do |field|
      field.label = 'Topic'
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'type_ssi' do |field|
      field.label = 'Type'
      field.show = true
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'physical_format_ssi' do |field|
      field.label = 'Physical Format'
      field.show = true
      field.index_range = 'A'..'Z'
      field.limit = -1 # Blacklight's default is 100, but we do not want to limit
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'formal_subject_ssim' do |field|
      field.label = 'Subject Headings'
      field.index_range = 'A'..'Z'
      field.limit = -1 # Blacklight's default is 100, but we do not want to limit
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'rights_status_ssi' do |field|
      field.label = 'Rights Status'
      field.index_range = 'A'..'Z'
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'collection_name_ssi' do |field|
      field.label = 'Contributor'
      field.index_range = 'A'..'Z'
      field.limit = -1 # Blacklight's default is 100, but we do not want to limit
      field.sort = 'index'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'dat_ssim' do |field|
      field.label = 'Date Created'
      field.collapse = false
      field.range = true
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
  end
end
