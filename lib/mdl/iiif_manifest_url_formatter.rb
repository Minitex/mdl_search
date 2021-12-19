module MDL
  class IiifManifestUrlFormatter
    class << self
      def format(doc)
        collection, id = doc['id'].split('/')
        "/iiif/#{collection}:#{id}/manifest.json"
      end
    end
  end
end
