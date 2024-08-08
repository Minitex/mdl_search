module MDL
  class CiteTranscript
    attr_reader :solr_doc

    def initialize(solr_doc: {})
      @solr_doc = solr_doc
    end

    ###
    # @return [Hash]
    def to_hash
      return {} if transcript.nil?

      {
        focus: false,
        type: 'transcript',
        label: 'Transcript',
        transcript:
      }
    end

    ###
    # @return [String, nil]
    def transcript
      @transcript ||= begin
        if solr_doc['transcription_tesi']
          solr_doc['transcription_tesi']
        elsif solr_doc['transcription_tesim']
          solr_doc['transcription_tesim'].join("\n\n")
        else
          nil
        end
      end
    end
  end
end
