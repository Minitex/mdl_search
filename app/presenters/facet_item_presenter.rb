class FacetItemPresenter < Blacklight::FacetItemPresenter
  def label
    label_value = if facet_item.respond_to?(:label)
      facet_item.label
    else
      value
    end

    if facet_config.helper_method
      view_context.public_send(facet_config.helper_method, label_value)
    elsif facet_config.query && facet_config.query[label_value]
      facet_config.query[label_value][:label]
    elsif value == Blacklight::SearchState::FilterField::MISSING
      I18n.t("blacklight.search.facets.missing")
    elsif facet_config.date
      localization_options = facet_config.date == true ? {} : facet_config.date
      I18n.l(Time.zone.parse(label_value), **localization_options)
    else
      label_value
    end
  end
end
