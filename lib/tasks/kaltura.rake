namespace :kaltura do
  desc <<~DESC
    Generate a new session token for API access - good for 10 years. Requires
    a Kaltura username and User Secret (accessible at https://kmc.kaltura.com).
    Assign the output to the KALTURA_SESSION environment variable to provide
    API access to this application.
  DESC
  task generate_token: :environment do
    require 'io/console'
    require 'kaltura'

    print 'Enter your Kaltura username: '
    user_id = STDIN.gets.chomp
    secret = IO.console.getpass 'Enter your Kaltura User Secret: '

    partner_id = 1369852
    session_type = Kaltura::KalturaSessionType::USER
    expiry = 315_360_000 # ~10 years - assuming no leap years ¯\_(ツ)_/¯
    privileges = ''

    config = Kaltura::KalturaConfiguration.new
    client = Kaltura::KalturaClient.new(config)

    puts client.session_service.start(
      secret,
      user_id,
      session_type,
      partner_id,
      expiry,
      privileges
    )
  end
end
