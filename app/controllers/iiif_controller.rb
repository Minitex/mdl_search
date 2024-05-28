class IiifController < ApplicationController
  rescue_from StandardError do |e|
    logger.error("#{e.message}\n#{e.backtrace.take(5).join("\n")}")
    render json: { status: :internal_server_error }, status: :internal_server_error
  end

  FIELD_LIST = MDL::CiteDetails
    .field_configs
    .map(&:key)
    .to_set
    .merge(Set[
      'id',
      'title_ssi',
      'rights_uri_ssi',
      'contact_information_ssi',
      'iiif_manifest_ss',
      'format_tesi',
      'kaltura_audio_playlist_entry_data_ts',
      'dimensions_ssi',
      'kaltura_audio_playlist_ssi',
      'kaltura_audio_ssi',
      'rights_statement_ssi',
      'kaltura_video_playlist_ssi',
      'kaltura_audio_playlist_ssi',
      'kaltura_video_playlist_entry_data_ts',
      'kaltura_video_ssi'
    ])
    .join(',')
    .freeze
  private_constant :FIELD_LIST

  include Blacklight::Catalog

  configure_blacklight do |config|
    config.default_document_solr_params = {
      qt: 'document',
      fl: FIELD_LIST,
      rows: 1
    }
  end

  def manifest
    _response, document = search_service.fetch(params[:id])
    if document.key?('iiif_manifest_ss')
      render body: document['iiif_manifest_ss'], content_type: 'application/json'
    else
      base_uri = URI::HTTPS.build(host: request.host)
      doc = MDL::BorealisDocument.new(document:)
      manifest = IiifManifest.new(doc, base_url: base_uri.to_s)
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
