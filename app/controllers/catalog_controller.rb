# frozen_string_literal: true
class CatalogController < ApplicationController
  before_action :permit_search_parameters, only: [:index, :range_limit, :oai]
  before_action :manage_pagination, only: :index
  ##
  # Determine whether to render the bookmarks control
  def render_bookmarks_control?
    false
  end

  ##
  # Determine whether to render the saved searches link
  def render_saved_searches?
    false
  end

  include Blacklight::Catalog
  include BlacklightOaiProvider::Controller

  include BlacklightRangeLimit::ControllerOverride
  include BlacklightAdvancedSearch::Controller


  ## Blacklight Override
  ## We are turning :layout => true in order to get the full layout rendering
  ## on missing items
  ##
  # when a request for /catalog/BAD_SOLR_ID is made, this method is executed.
  # Just returns a 404 response, but you can override locally in your own
  # CatalogController to do something else -- older BL displayed a Catalog#inde
  # page with a flash message and a 404 status.
  def invalid_document_id_error(exception)
    raise exception unless Pathname.new("#{Rails.root}/public/404.html").exist?

    error_info = {
      "status" => "404",
      "error"  => "#{exception.class}: #{exception.message}"
    }

    respond_to do |format|
      format.xml  { render :xml  => error_info, :status => 404 }
      format.json { render :json => error_info, :status => 404 }

      # default to HTML response, even for other non-HTML formats we don't
      # neccesarily know about, seems to be consistent with what Rails4 does
      # by default with uncaught ActiveRecord::RecordNotFound in production
      format.any do
        # use standard, possibly locally overridden, 404.html file. Even for
        # possibly non-html formats, this is consistent with what Rails does
        # on raising an ActiveRecord::RecordNotFound. Rails.root IS needed
        # for it to work under testing, without worrying about CWD.
        render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => true, :content_type => 'text/html'
      end
    end
  end

  def run_search!
    search_service.search_results
  end

  def permit_search_parameters
    params.permit!
  end

  # get search results from the solr index
  def index
    if params == {"controller"=>"catalog", "action"=>"index"}
      @response, @document_list = Rails.cache.fetch("home_search", expires_in: 12.hours) do
        run_search!
      end
    else
      @response, @document_list = run_search!
    end
    super
  end

  def search_facet_url(*args)
    current_exhibit ? exhibit_search_facet_url(*args) : super
  end

  # overrides /blacklight/controllers/concerns/blacklight/catalog
  # add a param to allow the search history to be cleared on an item click
  # get a single document from the index
  # to add responses for formats other than html or json see _Blacklight::Document::Export_
  def show
    _, @document = search_service.fetch(params[:id])
    @hide_previous_next = true if params[:pn] == 'false'

    respond_to do |format|
      format.html { @search_context = setup_next_and_previous_documents }
      format.json { render json: { response: { document: @document } } }
      additional_export_formats(@document, format)
    end
  end

  # Override blacklights limit param for facets.
  # See: def solr_facet_params - blacklight-5.7.2/lib/blacklight/solr_helper.rb
  def facet_list_limit
    (params[:limit]) ? params[:limit] : 20
  end

  private

  ###
  # When a user changes their per_page count, we want to try
  # to keep them relatively close to their previous position
  # in the result set. We're leaning on the flash here to avoid
  # a redirect loop.
  def manage_pagination
    return if flash.key?(:pagination_managed)
    per_page = params.fetch(:per_page) { return }
    return unless request.referrer

    per_page = per_page.to_i
    prev_page, previous_per_page = parse_referrer_pagination_params
    return if prev_page <= 1 # no page, or coming from page 1
    return if previous_per_page == per_page # per_page is unchanged

    offset = previous_per_page * (prev_page - 1) + 1
    new_page = offset / per_page + ((offset % per_page).zero? ? 0 : 1)
    return if new_page == params[:page].to_i # offset still on prev page number

    redirect_to(
      search_catalog_path(
        **params
          .except(:action, :controller)
          .merge(page: new_page, per_page: per_page)
      ),
      flash: { pagination_managed: true }
    )
  end

  def parse_referrer_pagination_params
    prev_params = CGI.parse(URI(request.referrer).query)
    previous_page, _ = prev_params['page']
    previous_per_page, _ = prev_params['per_page']
    previous_per_page ||= blacklight_config.default_per_page
    [previous_page.to_i, previous_per_page.to_i]
  end

  configure_blacklight do |config|
    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)
    config.add_show_tools_partial(:citation)

    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')
    # default advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    # config.advanced_search[:qt] ||= 'advanced'
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] ||= {}

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 20,
      fl: '*',
      hl: 'on',
      'hl.fl': '*',
      'hl.fragsize': 0
    }

    config.default_per_page = 25

    config.autocomplete_enabled = false
    config.autocomplete_path = 'suggest'

    config.index.thumbnail_method = :cached_thumbnail_tag
    config.show.thumbnail_method = :cached_thumbnail_tag

    config.view.gallery(
      default: false,
      partials: [:index],
      icon_class: 'glyphicon-th',
      classes: []
    )

    ###
    # Spotlight additions
    config.show.oembed_field = :oembed_url_ssm
    config.show.partials.insert(1, :oembed)
    config.show.tile_source_field = :image_uri_ssi
    config.index.tile_source_field = :image_uri_ssi
    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [25,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  qt: 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # fl: '*',
    #  # rows: 1
    #  # q: '{!term f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.title_field = 'title_tesi'
    config.index.display_type_field = 'type_ssi'

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field 'topic_ssim' do |field|
      field.collapse = false
      field.label = 'Topic'
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'type_ssi' do |field|
      field.label = 'Type'
      field.collapse = false
      field.show = true
      field.limit = 10
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'physical_format_ssi' do |field|
      field.label = 'Physical Format'
      field.show = true
      field.index_range = 'A'..'Z'
      field.collapse = false
      field.index = true
      field.limit = 5
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
    end
    config.add_facet_field 'placename_ssim' do |field|
      field.label = 'Location'
      field.index_range = 'A'..'Z'
      field.collapse = false
      field.limit = 5
      field.index = true
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'formal_subject_ssim' do |field|
      field.label = 'Subject Headings'
      field.show = true
      field.index_range = 'A'..'Z'
      field.collapse = false
      field.limit = 5
      field.index = true
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end
    config.add_facet_field 'collection_name_ssi' do |field|
      field.label = 'Contributor'
      field.index_range = 'A'..'Z'
      field.collapse = false
      field.limit = 5
      field.index = true
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
    end

    ###
    # This is from advanced search, and needs to be here in order
    # for the catalog/constraints partial to correctly represent
    # this field's name. Without it we show "Rights status ssi"
    config.add_facet_field 'rights_status_ssi' do |field|
      field.include_in_simple_search = false
      field.label = 'Rights Status'
      field.collapse = false
      field.item_presenter = FacetItemPresenter
      field.item_component = FacetItemComponent
      field.component = Blacklight::FacetFieldListComponent
    end

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'creator_tesi', label: 'Creator', highlight: true
    config.add_index_field 'dat_tesi', label: 'Date Created', highlight: true
    config.add_index_field 'description_ts', label: 'Description', highlight: true
    config.add_index_field 'contributing_organization_tesi', label: 'Contributing Institution', highlight: true
    config.add_index_field 'type_tesi', label: 'Type', highlight: true
    config.add_index_field 'physical_format_tesi', label: 'Format', highlight: true


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # config.add_show_field 'title_ssi', label: 'Title'


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
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

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = {
        qf: '$subject_qf',
        pf: '$subject_pf'
      }
    end

    ###
    # Advanced search fields
    #
    # These are also in the advanced controller blacklight config, but
    # must be here as well in order for the parameters to be recognized
    # when the advanced search form is submitted.
    #
    # Commenting out transcript until we have a good plan for transcript search results - PKS
    #config.add_search_field('transcript') do |field|
    #  field.include_in_simple_search = false
    #  field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
    #  field.solr_local_parameters = {
    #    qf: '$transcription_qf',
    #    pf: '$transcription_pf'
    #  }
    #end
    config.add_search_field('description') do |field|
      field.include_in_simple_search = false
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$description_qf',
        pf: '$description_pf'
      }
    end
    config.add_search_field('city_or_township') do |field|
      field.include_in_simple_search = false
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$city_or_township_qf',
        pf: '$city_or_township_pf'
      }
    end
    config.add_search_field('county') do |field|
      field.include_in_simple_search = false
      field.solr_parameters = { :'spellcheck.dictionary' => 'default' }
      field.solr_local_parameters = {
        qf: '$county_qf',
        pf: '$county_pf'
      }
    end


    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, dat_sort desc, title_sort asc', label: 'Relevance'
    config.add_sort_field 'title_sort asc, dat_sort asc', label: 'Title: A to Z'
    config.add_sort_field 'title_sort desc, dat_sort desc', label: 'Title: Z to A'
    config.add_sort_field 'creator_sort asc, title_sort asc', label: 'Creator: A to Z'
    config.add_sort_field 'creator_sort desc, title_sort desc', label: 'Creator: Z to A'
    config.add_sort_field 'dat_ssi asc, title_sort asc', label: 'Date: Oldest First'
    config.add_sort_field 'dat_ssi desc, title_sort desc', label: 'Date: Newest First'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    config.search_bar_component = ::SearchBarComponent

    ###
    # OAI
    config.oai = {
      provider: {
        repository_name: 'Minnesota Digital Library',
        repository_url: 'https://reflections.mndigital.org/catalog/oai',
        record_prefix: 'oai:reflections.mndigital.org',
        admin_email: 'swans062@umn.edu',
        sample_id: 'sll:22470'
      },
      document: {
        set_model: OaiSet,
        set_fields: [
          { solr_field: 'oai_set_ssi' }
        ]
      }
    }
  end
end
