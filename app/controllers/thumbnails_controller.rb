class ThumbnailsController < ApplicationController
  def show
    collection, id = params[:id].split(':')
    thumbnail = MDL::Thumbnail.new(collection:, id:, type: params[:type])

    redirect_to thumbnail.thumbnail_url, allow_other_host: true
  end
end
