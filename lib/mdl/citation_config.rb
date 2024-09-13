module MDL
  class CitationConfig
    attr_reader :document, :base_url, :download_request_url, :download_ready_url

    # @param borealis_doc [SolrDocument]
    # @param base_url [String]
    # @param download_request_url [String]
    # @param download_ready_url [String]
    def initialize(document:, base_url:, download_request_url:, download_ready_url:)
      @document = document
      @base_url = base_url
      @download_request_url = download_request_url
      @download_ready_url = download_ready_url
    end

    def to_json(*)
      config.to_json
    end

    private

    def config
      [].tap do |c|
        c << CiteDetails.new(solr_doc: document).to_hash
        c << CiteCitation.new(solr_doc: document, base_url: base_url).to_hash
        c << CiteDownload.new(assets: download_assets).to_hash
        c << download_archive if include_archive_option?
        c << CiteTranscript.new(solr_doc: document).to_hash
        c << CiteTranslation.new(solr_doc: document).to_hash
        c.map!(&:presence)
        c.compact!
      end
    end

    def download_assets
      @download_assets ||= begin
        manifest = if document.key?('iiif_manifest_ss')
          JSON.parse(document['iiif_manifest_ss'])
        else
          doc = BorealisDocument.new(document:)
          IiifManifest.new(doc, base_url:).as_json
        end
        CiteDownloadAssetsFromManifest.call(manifest)
      end
    end

    def include_archive_option?
      return false unless document.key?('iiif_manifest_ss')
      return false unless download_assets.size > 1
      true
    end

    def download_archive
      CiteDownloadArchive.new(
        ready_url: download_ready_url,
        download_request_url: download_request_url,
        item_id: document['id']
      ).to_hash
    end
  end
end
