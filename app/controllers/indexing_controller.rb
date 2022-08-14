class IndexingController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization

  FACET_FIELD = 'oai_set_ssi'.freeze

  include Blacklight::Catalog

  blacklight_config.configure do |config|
    ###
    # Using an arbitrary high number to effectively remove the
    # limit Blacklight applies to the facet query. Setting a
    # limit on the facet itself (-1) doesn't seem to work in
    # this case as it does in AdvancedController. The actual
    # total count for the oai_set_ssi facet is around 200, so
    # this should give us some room to grow.
    config.default_more_limit = 1_000_000
    config.add_facet_field FACET_FIELD do |field|
      field.index_range = 'A'..'Z'
    end
  end

  def index
    @collections = collections
  end

  def create
    args = { set_specs: [params.require(:collection)], from: '1970-01-01' }
    if params[:date].present?
      args[:from] = Date.parse(params[:date]).iso8601
    end
    MDL::ETL.new.run(args)
    redirect_to indexing_path, flash: { notice: 'Queued collection for indexing' }
  end

  private

  def collections
    facet = blacklight_config.facet_fields[FACET_FIELD]
    response = search_service.facet_field_response(facet.key, {})
    response.aggregations[facet.key].items.map do |item|
      set_spec, collection_name, _ = item.value.split(MDL::OaiSetFormatter.delimiter)
      [collection_name, set_spec]
    end.sort_by(&:first)
  end

  def check_authorization
    authorize! :index, :collections
  end
end
