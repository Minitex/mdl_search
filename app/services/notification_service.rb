#
# Provides a facility for Slack channel notifications
#
class NotificationService
  HEADERS = { 'content-type': 'application/json' }.freeze
  private_constant :HEADERS

  class << self
    ###
    # @param message [String]
    # @return [void]
    def notify(message, url: default_url)
      url ? notify_slack(message, url:) : log(message)
      nil
    end

    private

    def notify_slack(message, url:)
      body = <<~JSON.strip
        {"message":"#{message}"}
      JSON
      Net::HTTP.post(URI(url), body, HEADERS)
    end

    def log(message)
      msg = <<~MSG
        ** Slack notification skipped because SLACK_NOTIFY_URL is unset **
        {"message":"#{message}"}
      MSG
      Rails.logger.debug(msg)
    end

    def default_url = ENV['SLACK_NOTIFY_URL']
  end
end
