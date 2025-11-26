class NearbysController < ApplicationController
  protect_from_forgery except: :show

  def show
    render json: nearbys_with_anchors, :callback => params[:callback]
  end

  def nearbys_with_anchors
    nearbys.map { |nearby| nearby.merge(anchor: '') }
  end

  def nearbys
    @nearbys ||= Nearby.search(pt: coords, d: distance)
  end

  def coords
    params[:coordinates].gsub /\+/, '.'
  end

  def distance
    (params[:distance]) ? params[:distance] : 35
  end
end
