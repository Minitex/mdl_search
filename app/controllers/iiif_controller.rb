class IiifController < ApplicationController
  include Blacklight::SearchHelper

  def manifest
    _response, document = fetch(params[:id])
    doc = MDL::BorealisDocument.new(document: document)
    manifest = IiifManifest.new(doc)
    render json: manifest
  end
end
