class CaptchaValidator
  ValidationError = Class.new(StandardError)

  class << self
    # @param token [String] the token from the recaptcha widget
    # @return [void]
    def call(token)
      response = Net::HTTP.get_response(validation_uri(token))
      Rails.logger.info "got recaptcha response with status #{response.code}"
      Rails.logger.info response.body
      raise ValidationError unless response.code == '200'
      raise ValidationError unless JSON.parse(response.body)['success']
    end

    private

    def validation_uri(token)
      URI::HTTPS.build(
        host: 'www.google.com',
        path: '/recaptcha/api/siteverify',
        query: "secret=#{ENV['RECAPTCHA_SECRET_KEY']}&response=#{token}"
      )
    end
  end
end
