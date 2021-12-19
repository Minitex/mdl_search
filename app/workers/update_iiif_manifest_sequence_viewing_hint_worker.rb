class UpdateIiifManifestSequenceViewingHintWorker
  include Sidekiq::Worker
  sidekiq_options queue: :iiif_search

  def perform(collection)
    UpdateIiifManifestSequenceViewingHint.for_collection(collection)
  end
end
