class TracksController < ApplicationController
  before_action :set_cors_headers

  def entry
    respond_to do |format|
      format.vtt do
        content = fetch_vtt_content
        head :not_found and return unless content.present?

        vtt_content = JSON.parse(content).dig(params[:entry_id])
        head :not_found and return unless vtt_content.present?

        render plain: "WEBVTT\n\n#{vtt_content}", content_type: 'text/vtt'
      end
    end
  end

  private

  # TODO: remove
  def set_cors_headers
    headers['access-control-allow-origin'] = '*'
    headers['access-control-allow-methods'] = 'GET'
    headers['access-control-allow-headers'] = 'Accept, Accept-Language, Content-Type, Authorization'
  end

  def fetch_vtt_content
    client = Blacklight.default_index.connection
    response = client.get('select', params: {
      defType: 'edismax',
      fq: "id:\"#{RSolr.solr_escape(params[:id])}\"",
      fl: 'captions_ts',
      qt: 'search',
      rows: 1,
      q: '*:*',
      wt: 'json'
    })
    docs = Array(response.dig('response', 'docs'))
    docs.first&.[]('captions_ts')
  end
end
