class SearchResult
  ATTRIBUTES = %i(title creator description contributor type format)
  # @param result [Nokogiri::XML::Element]
  # @return [SearchResult]
  def self.from(result)
    title = result.css('.document-title-heading a').text.squish
    creator = result.css('dd.blacklight-creator_tesi').text.squish
    description = result.css('dd.blacklight-description_ts').text.squish
    contributor = result.css('dd.blacklight-contributing_organization_tesi').text.squish
    type = result.css('dd.blacklight-type_tesi').text.squish
    format = result.css('dd.blacklight-physical_format_tesi').text.squish
    new(
      title: title,
      creator: creator,
      description: description,
      contributor: contributor,
      type: type,
      format: format
    )
  end

  attr_reader(*ATTRIBUTES)

  # @param attrs [Hash]
  def initialize(attrs)
    ATTRIBUTES.each do |attr|
      send("#{attr}=", attrs[attr])
    end
    freeze
  end

  private

  attr_writer(*ATTRIBUTES)
end

module SearchHelpers
  def self.included(base)
    base.subject(:results) { search_results }
  end

  def search_results
    doc = Nokogiri::HTML(response.body)
    doc.css('.document').map do |result|
      SearchResult.from(result)
    end
  end
end

RSpec.configure do |c|
  c.include SearchHelpers, type: :request
end
