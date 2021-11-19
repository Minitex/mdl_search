class UpdateIiifManifestServiceDescriptionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iiif_search

  def perform(collection)
    UpdateIIIFManifestServiceDescription.for_collection(collection)
  end
end
