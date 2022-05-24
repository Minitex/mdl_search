module MDL
  ###
  # This isn't a formatter, in the sense that it transforms
  # CDM data into MDL Solr data. This is here to determine
  # which documents should be processed for IIIF search.
  # Without an overhaul of the CDMBL gem, this is the most
  # pragmatic way to hook into the existing data ingestion
  # pipeline.
  class QueueIiifSearchProcessing
    class << self
      def format(doc)
        if iiif_search_candidate?(doc)
          IiifSearchProcessingWorker.perform_async(doc['id'].sub('/', ':'))
        end
        nil
      end

      private

      def iiif_search_candidate?(doc)
        has_ocr?(doc) || text_type?(doc) || ocr_candidate?(doc)
      end

      def has_ocr?(doc)
        [doc, *Array(doc['page'])].any? { |p| p['cdmhasocr'] == '1' }
      end

      def text_type?(doc)
        doc['type'] == 'Text'
      end

      def ocr_candidate?(doc)
        doc['format'] == 'image/jp2' && (doc['transc'].present? || doc['transl'].present?)
      end
    end
  end
end
