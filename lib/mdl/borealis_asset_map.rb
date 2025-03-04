module MDL
  class BorealisAssetMap
    MAPPING = {
      'image/jpeg' => BorealisImage,
      'image/jp2' => BorealisImage,
      'image/jpg' => BorealisImage,
      'tif' => BorealisImage,
      'jp2' => BorealisImage,
      'jpg' => BorealisImage,
      'audio/mp3' => BorealisAudio,
      'audio/mpeg' => BorealisAudio,
      'mp3' => BorealisAudio,
      'mp4' => BorealisVideo,
      'video/dv' => BorealisVideo,
      'video/mp4' => BorealisVideo,
      'video/dvvideo/mp4' => BorealisVideo,
      'video/mpeg4' => BorealisVideo,
      'pdf' => BorealisPdf,
      'pdfpage' => BorealisPdf,
      'application/pdf' => BorealisPdf,
      'pptx' => BorealisPpt
    }.freeze
    private_constant :MAPPING

    REGEX = /;|\n|\s/
    private_constant :REGEX

    ###
    # @param format_field [String]
    # @return [Class<BorealisAsset>]
    def self.[](format_field)
      sanitized = (format_field || 'jp2').gsub(REGEX, '').downcase
      MAPPING.fetch(sanitized)
    end
  end
end
