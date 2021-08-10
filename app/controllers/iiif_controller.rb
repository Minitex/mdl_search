class IiifController < ApplicationController
  include Blacklight::SearchHelper

  def manifest
    response, document = fetch(params[:id])
    asset = MDL::BorealisDocument.new(document: document).assets[0]
    render json: asset.to_manifest_json
  end
end
