module MDL
  class IiifManifestUrlFormatter
    class << self
      def format(doc)
        borealis_doc = BorealisDocument.new(document: doc)
        return unless borealis_doc.first_key == 'image'
        collection, id = doc['id'].split('/')
        "/iiif/#{collection}:#{id}/manifest.json"
      end
    end
  end
end