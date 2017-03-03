module MDL
  class BorealisAssetMap
    attr_reader :format_field,
                :video_klass,
                :audio_klass,
                :pdf_klass,
                :ppt_klass,
                :image_klass

    def initialize(format_field: 'jp2',
                   video_klass: BorealisVideo,
                   audio_klass: BorealisAudio,
                   pdf_klass: BorealisPDF,
                   ppt_klass: BorealisPPT,
                   image_klass: BorealisImage)

      @format_field = format_field
      @video_klass  = video_klass
      @audio_klass  = audio_klass
      @pdf_klass    = pdf_klass
      @ppt_klass    = ppt_klass
      @image_klass  = image_klass
    end

    def map
      mapping.fetch(format_field)
    end

    def mapping
      {
        'image/jp2' => image_klass,
        'tif' => image_klass,
        'jp2' => image_klass,
        'jpg' => image_klass,
        'mp3' => audio_klass,
        'mp4' => video_klass,
        'video/DV' => video_klass,
        'video/mp4' => video_klass,
        'pdf' => pdf_klass,
        'pdfpage' => pdf_klass,
        'application/pdf' => pdf_klass,
        'pptx' => ppt_klass
      }
    end
  end
end