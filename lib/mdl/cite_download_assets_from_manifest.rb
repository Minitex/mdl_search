module MDL
  #
  # Using the manifest JSON stored on the Solr document, we
  # can produce a collection of objects that know their label,
  # thumbnail, and download sources.
  #
  module CiteDownloadAssetsFromManifest
    ###
    # @param manifest [Hash] parsed IIIF manifest JSON
    # @return [Array<MDL::DownloadAsset>]
    def self.call(manifest)
      Array(manifest.dig('sequences', 0, 'canvases'))
        .map(&DownloadAsset.method(:from_iiif_canvas))
    end
  end
end
