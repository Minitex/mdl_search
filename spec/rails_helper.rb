# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'vcr'
require 'webmock/rspec'
require 'sidekiq/testing'
Sidekiq::Testing.inline!


#### CAPYBARA / SELENIUM
# Capybara config with docker-compose environment vars
require 'capybara/rails'
require 'capybara/rspec'
Capybara.default_driver = :selenium

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    record: ENV.fetch('VCR_RECORD_MODE', :once).to_sym,
    match_requests_on: %i(method uri body query)
  }
  config.ignore_localhost = true
  # config.debug_logger = $stdout
  config.filter_sensitive_data('<KS>', :kaltura) do |int|
    req = int.request
    next unless req.uri.match(%r{www.kaltura.com})

    case req.method
    when :post then JSON.parse(req.body)['ks']
    when :get then req.uri.match(/ks=(.*)\z/).captures[0]
    end
  end
  config.filter_sensitive_data('<kalsig>', :kaltura) do |int|
    req = int.request
    next unless req.method == :post
    next unless req.uri.match(%r{www.kaltura.com})

    JSON.parse(req.body)['kalsig']
  end
  ###
  # VCR hook called before the cassette is matched against an outgoing request.
  # Here we must reverse the effects of the +filter_sensitive_data+ hooks above.
  # Unfortunately, that includes recalculating the request signature applied by
  # the Kaltura SDK.
  config.before_playback(:kaltura) do |int|
    req = int.request
    next unless req.uri.match(%r{www.kaltura.com})

    case req.method
    when :get then req.uri.sub!('<KS>', ENV['KALTURA_SESSION'].to_s)
    when :post
      req.body.sub!('<KS>', ENV['KALTURA_SESSION'].to_s)
      client = Kaltura::KalturaClient.new(Kaltura::KalturaConfiguration.new)
      params = JSON.parse(req.body).except('kalsig')
      sig = client.signature(params)
      params['kalsig'] = sig
      req.body = JSON.generate(params)
    end
  end
end

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

require Rails.root.join('spec/requests/oai_response_examples')

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  if ENV.fetch('CI', false)
    config.around(:each, type: :feature) do |spec|
      Capybara.current_driver = :selenium_chrome_headless
      spec.run
      Capybara.use_default_driver
    end

    config.after(:each, type: :feature) do |e|
      next unless e.exception
      save_page
      save_screenshot
    end
  end
end
