class IxifManifest
  delegate :collection,
           :id,
           :title,
           to: :borealis_document

  attr_reader :borealis_document

  def initialize(borealis_document)
    @borealis_document = borealis_document
  end

  def as_json(*)
    {
      '@context' => ['http://iiif.io/api/presentation/2/context.json'],
      'id' => "https://collection.mndigital.org/iiif/info/#{collection}/#{id}/manifest.json",
      'type' => 'sc:Manifest',
      'label' => title,
      'metadata' => [],
      'mediaSequences' => [
        {

        }
      ]
    }
  end
end
