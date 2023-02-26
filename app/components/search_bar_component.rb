class SearchBarComponent < Blacklight::SearchBarComponent
  attr_reader :url

  def advanced_search_enabled?
    false
  end
end
