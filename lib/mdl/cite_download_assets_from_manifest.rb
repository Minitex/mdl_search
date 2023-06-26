module MDL
  #
  # Using the manifest JSON stored on the Solr document, we
  # can produce a collection of objects that know their label,
  # thumbnail, and download sources.
  #
  module CiteDownloadAssetsFromManifest
    IIIF_V2 = 'http://iiif.io/api/presentation/2/context.json'.freeze
    IIIF_V3 = 'http://iiif.io/api/presentation/3/context.json'.freeze

    ###
    # @param manifest [Hash] parsed IIIF manifest JSON
    # @return [Array<MDL::DownloadAsset>]
    def self.call(manifest)
      case manifest['@context']
      when IIIF_V2
        DownloadAsset.assets_from_manifest_v2(manifest)
      when IIIF_V3
        DownloadAsset.assets_from_manifest_v3(manifest)
      else
        raise ArgumentError.new('unsupported IIIF manifest format')
      end
    end
  end
end
