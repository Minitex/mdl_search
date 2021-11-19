class IiifController < ApplicationController
  include Blacklight::SearchHelper

  rescue_from StandardError do |e|
    logger.error("#{e.message}\n#{e.backtrace.take(5).join("\n")}")
    render json: { status: :internal_server_error }, status: :internal_server_error
  end

  def manifest
    _response, document = fetch(params[:id])
    if document.key?('iiif_manifest_ss')
      render body: document['iiif_manifest_ss'], content_type: 'application/json'
    else
      doc = MDL::BorealisDocument.new(document: document)
      manifest = IiifManifest.new(doc)
      render json: manifest
    end
  end

  def search
    response = IiifSearchService.call(
      query: params[:q],
      item_id: params[:id]
    )
    render json: response
  end

  def autocomplete
    response = IiifSearchAutocompleteService.call(
      query: params[:q],
      item_id: params[:id]
    )
    render json: response
  end
end
