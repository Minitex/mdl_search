class UpdateIiifManifestServiceDescriptionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iiif_search

  def perform(collection)
    UpdateIiifManifestServiceDescription.for_collection(collection)
  end
end
