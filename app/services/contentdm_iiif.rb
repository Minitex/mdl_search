require 'net/http'

class ContentdmIiif
  attr_accessor :base_url, :collection, :id
  def initialize(base_url: 'https://cdm16022.contentdm.oclc.org',
                 collection: '',
                 id: '')
    @base_url   = base_url
    @collection = collection
    @id         = id
  end

  def info
    contentdm_info.merge(local_info)
  end

  def contentdm_info
    JSON.parse(Net::HTTP.get_response(info_uri).body)
  end

  def local_info
    {
      "@id" => "#{base_url}/digital/iiif/#{collection}/#{id}",
    }
  end

  def info_uri
    URI("#{base_url}/digital/iiif/#{collection}/#{id}/info.json")
  end
end
