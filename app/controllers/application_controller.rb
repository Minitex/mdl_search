class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  ###
  # Before we include Spotlight::Controller, we need to get a
  # reference to Blacklight::Controller's search_facet_url because
  # Spotlight provides one that's not compatible with our app.
  # Then, in CatalogController, we define our own search_facet_url
  # that mimic's Spotlight's when we have +current_exhibit+, but
  # falls back to our aliased method otherwise.
  alias_method :blacklight_search_facet_url, :search_facet_url
  include Spotlight::Controller

  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_after_action :discard_flash_if_xhr

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
end
