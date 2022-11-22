require 'json'
module MDLCatalogViewHelper

  def search_text
    current_search_session.query_params.fetch('q', '')
  end
end
