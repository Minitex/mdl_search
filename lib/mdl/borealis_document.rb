require 'json'

###
# Wraps a Solr document hash. Accessing values of the document
# itself use the Solr fields, whereas accessing attributes of a
# compound document's pages uses the ContentDM attribute names.
module MDL
  class BorealisDocument
    attr_reader :document,
                :collection,
                :id

    # @param document [Hash] Solr document
    def initialize(document: {})
      @document        = document
      @collection, @id = document['id'].split(':')
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
        [
          asset(
            asset_klass(format_field),
            id,
            title
          )
        ]
      else
        compounds.filter_map do |compound|
          next if bad_compound?(compound)
          asset(
            asset_klass(compound_format(compound)),
            compound['pageptr'],
            compound['title']
          )
        end
      end
    end

    def compound_format(compound)
      compound['pagefile'].split('.').last
    end

    def asset(asset_klass, id, title = false)
      if !title
        asset_klass.new(id:, collection:, document:)
      else
        asset_klass.new(id:, collection:, title:, document:)
      end
    end

    # BorealisAssetMap returns a BorealisAsset subclass based on the format
    # field of a document. If an error occurs, it will generally be here.
    # Format field data is hand entered and sometimes incorrectly so.
    def asset_klass(format_field)
      # binding.pry
      BorealisAssetMap[format_field]
    end

    def compounds
      JSON.parse(document.fetch('compound_objects_ts', '[]'))
    end

    def format_field
      document.fetch('format_tesi') do
        # if format_tesi is missing, attempt to map using other clues
        case document['type_ssi']
        when /sound recording/i then 'audio/mp3'
        when /moving image/i then 'video/mp4'
        else 'jp2'
        end
      end
    end

    def bad_compound?(compound)
      compound['pagefile'].is_a?(Hash)
    end
  end
end
