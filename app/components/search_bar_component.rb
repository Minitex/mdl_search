class SearchBarComponent < Blacklight::SearchBarComponent
  attr_reader :url

  def hidden_field_params
    @params.except(:exhibit_id)
  end

  def advanced_search_enabled?
    false
  end
end
