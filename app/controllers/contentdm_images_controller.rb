class ContentdmImagesController < ApplicationController

  def info
    render json: ContentdmIiif.new(collection: identifiers.first, id: identifiers.last).info
  end

  private

  def identifiers
    image_params['id'].split(':')
  end

  def image_params
    params.permit(:id)
  end

end
