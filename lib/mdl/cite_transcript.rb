module MDL
  class CiteTranscript
    attr_reader :solr_doc
    def initialize(solr_doc: {})
      @solr_doc = solr_doc
    end

    def to_hash
      if solr_doc['transcription_tesi']
        {
          focus: false,
          type: 'transcript',
          label: 'Transcript',
          transcript: solr_doc['transcription_tesi']
        }
      elsif solr_doc['transcription_tesim']
        {
          focus: false,
          type: 'transcript',
          label: 'Transcript',
          transcript: solr_doc['transcription_tesim'].join("\n\n")
        }
      else
        {}
      end
    end
  end
end
