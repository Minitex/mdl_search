module MDL
  class BorealisPDFViewer < BorealisAssetsViewer
    def type
      'pdf'
    end

    # Emtpy transcript section below is for backwards compatibility
    # Need to refactor react-borealis to make this not required
    def to_viewer
      {
        'transcript' => {
            'texts' => [],
            'label' => 'PDF'
        },
        'type' => type,
        'config' => {
          'height' => 800,
          'width' => '100%',
        },
       'thumbnail' => '/images/reflections-pdf-icon.png',
       'values' => values
      }
    end

    def values
      assets.each_with_index.map do |pdf, i|
        {
          'src' => pdf_src(pdf, i),
          'thumbnail' => pdf.thumbnail,
          'transcript' => {
            'texts' => pdf.transcripts,
            'label' => 'PDF'
          }
        }
      end
    end

    # Collection "p16022coll64" is special case: it is a compound object
    # made-up of a single multi-page PDF. We are working on ways to detect
    # these sorts of cases. For now, this behavior is hard-coded
    def pdf_src(pdf, i)
      if pdf.collection == 'p16022coll64'
        "#{pdf.src}?page=#{i + 1}"
      else
        pdf.src
      end
    end
  end
end
