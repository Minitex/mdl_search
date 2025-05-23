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

    config.load_defaults 7.1
    config.active_support.cache_format_version = 7.1
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::HashWithIndifferentAccess, Symbol]

    config.add_autoload_paths_to_load_path = false
    config.autoload_lib(ignore: %w(assets tasks))
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.precompile += [
      'catalog_show',
      # Move this to app/assets/config/manifest.js when upgrading to Sprockets 4
      # https://github.com/projectblacklight/spotlight/releases/tag/v4.0.0
      'spotlight/manifest.js'
    ]

    # Allow iframe embedding in Tableau
    config.action_dispatch.default_headers['X-Frame-Options'] = 'ALLOW-FROM https://tableau.umn.edu/'

    # Compress pages
    config.middleware.use Rack::Deflater

    config.spotlight_mount_path = '/exhibits'

    config.to_prepare do
      Dir.glob("#{Rails.root}/app/overrides/**/*_override.rb").each do |override|
        require_dependency override
      end
    end
  end
end
