class ListsController < ApplicationController
  def index
  end

  def show
  end

  def items
    solr_response = fetch_items
    render json: ListItemsResponse.from_solr(solr_response)
  end

  private

  def fetch_items
    fq = params[:ids]
      .split(',')
      .map { |id| "id:\"#{RSolr.solr_escape(id)}\"" }
      .join(' OR ')
    client = SolrClient.new
    client.connect.get('select', params: {
      defType: 'edismax',
      fq: fq,
      fl: 'id,title_ssi,description_ts,collection_name_ssi',
      qt: 'search',
      rows: 50,
      q: '*:*',
      wt: 'json'
    })
  end
end
