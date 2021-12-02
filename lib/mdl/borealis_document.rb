require 'json'

###
# Careful with this... looks half of the code here expects
# a document from Solr, and the other half expects one from
# ContentDM. We should get that sorted out.
module MDL
  class BorealisDocument
    attr_reader :document,
                :asset_map_klass,
                :to_viewers_klass,
                :collection,
                :id

    def initialize(document: {},
                   asset_map_klass: BorealisAssetMap,
                   to_viewers_klass: MDL::BorealisAssetsToViewers)
      @document         = document
      @collection, @id  = document['id'].split(':')
      @asset_map_klass  = asset_map_klass
      @to_viewers_klass = to_viewers_klass
    end

    def first_key
      to_viewer.keys.first
    end

    def initial_viewer_type
      assets.first.type
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
      document.fetch('iiif_manifest_url_ssi') do
        case assets.first
        when BorealisVideo, BorealisAudio
          "/iiif/#{document['id']}/manifest.json"
        else
          "https://cdm16022.contentdm.oclc.org/iiif/2/#{collection}:#{id}/manifest.json"
        end
      end
    end

    def title
      document.fetch('title_ssi', '')
    end

    def duration
      hours, minutes, seconds = document
        .fetch('dimensions_ssi') { return }
        .split(':')
        .map(&:to_i)
      minutes += hours * 60
      seconds += minutes * 60
    end

    def rights_uri
      document['rights_uri_ssi'] || document['rights_ssi']
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

    def format_field
      document.fetch('format_tesi', 'jp2').gsub(/;/, '')
    end

    def bad_compound?(compound)
      compound['pagefile'].is_a?(Hash)
    end
  end
end
