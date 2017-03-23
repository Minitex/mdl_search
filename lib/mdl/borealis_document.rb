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


    def to_viewer
      to_viewers_klass.new(assets: assets).viewers
    end

    def assets
      @assets = to_assets
    end

    private

    def to_assets
      if compounds.empty?
        [asset(asset_klass(format_field),
              id,
              transcript(document),
              title)]
      else
        compounds.map do |compound|
          asset(asset_klass(compound_format(compound)),
                compound['pageptr'],
                transcript(compound),
                compound['title'])

        end
      end
    end

    def compound_format(compound)
      compound['pagefile'].split('.').last
    end

    def asset(asset_klass, id, transcript, title = false)
      if !title
        asset_klass.new(id: id,
                        collection: collection,
                        transcript: transcript)
      else
        asset_klass.new(id: id,
                        collection: collection,
                        transcript: transcript,
                        title: title)
      end
    end

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
      document.fetch('format_ssi', 'jp2').gsub(/;/, '')
    end
  end
end