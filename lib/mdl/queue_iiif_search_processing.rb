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
        if [doc, *Array(doc['page'])].any? { |p| p['transc'].present? }
          IiifSearchProcessingWorker.perform_async(doc['id'].sub('/', ':'))
        end
        nil
      end
    end
  end
end
