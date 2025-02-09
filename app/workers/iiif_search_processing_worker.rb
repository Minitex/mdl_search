class IiifSearchProcessingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iiif_search

  def perform(identifier)
    MDL::ProcessDocumentForSearch.call(identifier)
  end
end
