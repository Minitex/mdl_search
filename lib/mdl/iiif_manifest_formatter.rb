module MDL
  class IiifManifestFormatter
    class << self
      def format(doc)
        borealis_doc = BorealisDocument.new(document: doc)
        return unless borealis_doc.first_key == 'image'
        collection, id = doc['id'].split('/')

        "https://cdm16022.contentdm.oclc.org/iiif/info/#{collection}/#{id}/manifest.json"
      end
    end
  end
end
