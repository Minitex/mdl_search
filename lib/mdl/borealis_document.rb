require 'json'

module MDL
  class BorealisDocument
    attr_reader :document, :asset_map_klass, :to_viewers_klass
    def initialize(document: {},
                   asset_map_klass: BorealisAssetMap,
                   to_viewers_klass: MDL::BorealisAssetsToViewers)
      @document         = document
      @asset_map_klass  = asset_map_klass
      @to_viewers_klass = to_viewers_klass
    end

    def first_key
      to_viewer.keys.first
    end

    # Output a viewer configuration hash
    # This hash can be converted with .to_json and passed to the Borealis React
    # component as its configuration. See views/catalog/_show_default.html.erb.
    def to_viewer
      to_viewers_klass.new(assets: assets).viewers
    end

    def assets
      @assets ||= to_assets
    end

    def manifest_url
      case assets.first
      when BorealisVideo, BorealisAudio
        assets.first.manifest_url
      else
        "https://cdm16022.contentdm.oclc.org/iiif/info/#{collection}/#{id}/manifest.json"
      end
    end

    private

    # Return a list of assets (all subclasses of BorealisAsset)
    # A non-compound record returns a list of one.
    def to_assets
      if compounds.empty?
        [asset(asset_klass(format_field),
              id,
              transcript(document),
              title)]
      else
        compounds.map do |compound|
          next if bad_compound?(compound)
          asset(asset_klass(compound_format(compound)),
                compound['pageptr'],
                transcript(compound),
                compound['title'])

        end.compact
      end
    end

    def compound_format(compound)
      compound['pagefile'].split('.').last
    end

    def asset(asset_klass, id, transcript, title = false)
      if !title
        asset_klass.new(id: id,
                        collection: collection,
                        transcript: transcript,
                        document: document)
      else
        asset_klass.new(id: id,
                        collection: collection,
                        transcript: transcript,
                        title: title,
                        document: document)
      end
    end

    # BorealisAssetMap returns a BorealisAsset subclass based on the format
    # field of a document. If an error occurs, it will generally be here.
    # Format field data is hand entered and sometimes incorrectly so.
    def asset_klass(format_field)
      asset_map_klass.new(format_field: format_field).map
    end

    def transcript(doc)
      doc.fetch('transc' , '')
    end

    def compounds
      JSON.parse(document.fetch('compound_objects_ts', '[]'))
    end

    def id
      document['id'].split(':').last
    end

    def collection
      @collection ||= document['id'].split(':').first
    end

    def title
      document.fetch('title_ssi', '')
    end

    def format_field
      document.fetch('format_tesi', 'jp2').gsub(/;/, '')
    end

    def bad_compound?(compound)
      compound['pagefile'].is_a?(Hash)
    end
  end
end
