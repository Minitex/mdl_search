require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MdlSearch
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: "locahost:3000", from: "noreply@example.com" }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.

    config.load_defaults 5.1

    config.enable_dependency_loading = true
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')


    unless Rails.env.production?
        # Work around sprockets+teaspoon mismatch:
        Rails.application.config.assets.precompile += %w(spec_helper.js)
    end

    # Compress pages
    config.middleware.use Rack::Deflater

    config.to_prepare do
      Dir.glob("#{Rails.root}/app/overrides/**/*_override.rb").each do |override|
        require_dependency override
      end
    end
  end
end
