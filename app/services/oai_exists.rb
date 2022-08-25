require 'json'

class OaiExists
  attr_reader :collection, :id, :endpoint, :prefix
  def initialize(collection: '',
                 id: '',
                 endpoint: 'http://cdm16022.contentdm.oclc.org/oai/oai.php',
                 prefix: 'oai:cdm16022.contentdm.oclc.org')
    @collection = collection
    @id = id
    @endpoint = endpoint
    @prefix = prefix
  end

  def exists?
    error?
  end

  private

  def error?
    (/The value of the identifier argument is unknown/ =~ error) != nil
  end

  def error
    json.fetch('OAI_PMH', {}).fetch('error', '')
  end

  def json
    Hash.from_xml(request)
  end

  def request
    Net::HTTP.get_response(uri).body
  end

  def get_record_query
    "verb=GetRecord&identifier=#{prefix}:#{collection}/#{id}"
  end

  def uri
    URI(url)
  end

  def url
    "#{endpoint}?#{get_record_query}&metadataPrefix=oai_dc"
  end
end
