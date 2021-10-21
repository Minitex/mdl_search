module MDL
  class IiifManifestFormatter
    class << self
      def format(doc, retries = 3)
        borealis_doc = BorealisDocument.new(document: doc)
        return unless borealis_doc.first_key == 'image'
        collection, id = doc['id'].split('/')

        url = "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/manifest.json"
        res = Net::HTTP.get_response(URI(url))
        self.format(doc, retries - 1) if res.code != '200' && retries.positive?

        parsed_response = JSON.parse(res.body)
        parsed_response['service'] = {
          '@context' => 'http://iiif.io/api/search/1/context.json',
          '@id' => "/iiif/#{collection}:#{id}/search",
          'profile' => 'http://iiif.io/api/search/1/search'
        }
        JSON.generate(parsed_response)
      end
    end
  end
end
