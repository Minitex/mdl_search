class ArchiveDownloadRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  SolrDocNotFound = Class.new(ArgumentError)

  before_action :check_document_exists, only: :create

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'not found' }, status: :not_found
  end

  rescue_from SolrDocNotFound do
    render json: { error: 'ID not found' }, status: :unprocessable_entity
  end

  def create
    adr = CreateArchiveDownloadRequest.call(mdl_identifier)
    render(
      json: adr,
      status: :created,
      location: archive_download_request_path(adr['id'])
    )
  end

  def show
    adr = ArchiveDownloadRequest.find(mdl_identifier)
    render(json: adr)
  end

  private

  def mdl_identifier
    params.require(:id)
  end

  def check_document_exists
    client = SolrClient.new
    response = client.connect.get('select', params: {
      defType: 'edismax',
      fq: "id:\"#{mdl_identifier}\"",
      qt: 'search',
      rows: 1,
      q: '*:*',
      wt: 'json'
    })
    count = response['response']['numFound']
    raise SolrDocNotFound.new(mdl_identifier) if count.zero?
  end
end
