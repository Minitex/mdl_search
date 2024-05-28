class TracksController < ApplicationController
  def show
    respond_to do |format|
      format.vtt do
        render plain: vtt_content, content_type: 'text/vtt'
      end
    end
  end

  private

  def vtt_content
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
