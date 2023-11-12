class NotificationWorker
  include Sidekiq::Worker

  ###
  # @param message [String]
  # @return [void]
  def perform(message) = NotificationService.notify(message)
end
