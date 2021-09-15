class OaiSet < BlacklightOaiProvider::SolrSet
  class << self
    # Returns array of sets for a solr document, or empty array if none are available.
    def sets_for(record)
      Array.wrap(@fields).map do |field|
        Array(record[field[:solr_field]]).map do |value|
          new("#{field[:label]}:#{value}")
        end
      end.flatten
    end
  end

  def initialize(spec)
    label = self.class.fields.first[:label]
    spec = "#{label}:#{spec}" unless spec.start_with?("#{label}:")
    super(spec)
    @spec, @name, @description = spec.sub("#{label}:", '').split(MDL::OaiSetFormatter.delimiter)
  end

  def name
    @name
  end

  def spec
    @spec
  end

  def solr_filter
    "setspec_ssi:#{@value}"
  end
end
