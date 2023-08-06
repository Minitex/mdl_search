#
# This controller gives us a way to dynamically vary the configuration
# of UniversalViewer based on any attributes of the Solr document being
# viewed. Due to the low number of dynamic values, we're currently
# just rendering an ERB template; but if the number grows, we likely
# should consider building an object structure that we can serialize to
# JSON instead.
#
class UvconfigController < ApplicationController
  include Blacklight::Catalog

  def show
    _response, document = search_service.fetch(params[:id])
    bd = MDL::BorealisDocument.new(document:)

    @left_panel_open = !bd.assets.first.playlist?
  end
end
