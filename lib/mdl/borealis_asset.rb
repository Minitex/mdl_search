module MDL
  class BorealisAsset
    attr_reader :id, :collection, :title, :document

    def initialize(id: '',
                   collection: '',
                   title: false,
                   document: {})
      @id         = id
      @collection = collection
      @title      = sanitize_field(title)
      @document   = document
    end

    def thumbnail_url
      Thumbnail.new(collection:, id:,).thumbnail_url
    end

    def thumbnail = thumbnail_url

    def iiif_compatable?
      false
    end

    def type
      :missing_type
    end

    def playlist?
      false
    end

    def download
      raise NotImplementedError
    end

    private

    def subtitle
      Array(document['identifier_ssim'])[id.to_i]
    end

    def sanitize_field(field)
      (field == {} || field == false || field == '') ? nil : field
    end
  end
end
