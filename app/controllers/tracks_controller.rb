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
    FetchCaptionService.fetch(params[:id])
  end
end
