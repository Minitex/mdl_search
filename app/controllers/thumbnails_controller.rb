class ThumbnailsController < ApplicationController
  ###
  # We have some methods in ThumbnailHelper which we use to
  # populate the src attribute of img tags for thumbnails. These
  # images are most likely cached in /public/assets/thumbnails, so
  # usually we will end up generating paths to those static thumbnail
  # files. But in the event of an uncached thumbnail image, we'll
  # generate a path to this controller action. We'll queue the cache
  # worker to write it to disk, and next time we can serve it
  # statically. Until then, we'll redirect to CONTENTdm to provide the
  # image.
  def show
    if thumbnail.cached?
      send_file thumbnail.file_path
    else
      CacheThumbnailWorker.perform_async(
        thumbnail.collection,
        thumbnail.id,
        thumbnail.type
      )
      redirect_to thumbnail.thumbnail_url
    end
  end

  private

  def thumbnail
    @thumbnail ||= begin
      collection, id = params[:id].split(':')
      MDL::Thumbnail.new(
        collection: collection,
        id: id,
        type: params[:type]
      )
    end
  end
end
