source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mysql2', '~> 0.4.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.5'
# # Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# # Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# # See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'
# gem 'mini_racer', '~> 0.3.1'
# # Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.2'
# # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# # bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'binding_of_caller'
  gem 'meta_request', '~> 0.7.2'
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-passenger'
  gem 'fontello_rails_converter'
  gem 'coveralls', require: false
end

group :test, :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'solr_wrapper', '>= 0.3'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'teaspoon-jasmine'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
end

gem 'blacklight', '~> 6.20'
gem 'blacklight_advanced_search', '~> 6.4'
gem 'blacklight_range_limit', '~> 6.5'
gem 'blacklight-spotlight', '~> 2.13'
gem 'blacklight_oai_provider', '~> 6.0'
gem 'chosen-rails', '~> 1.9'
gem 'rsolr', '2.3.0'
gem 'globalid', '0.4.2'
gem 'webpacker', '2.0'
gem 'cancancan', '~> 3.2.1'

# # CONTENTdm ETL
gem 'devise', '4.6.2'
gem 'devise-guests', '0.6.0'
gem 'hash_at_path', github: 'UMNLibraries/hash_at_path', ref: '92dafd3b06de2cbc861b9ad80dcadb3ed7274597'
gem 'contentdm_api', github: 'UMNLibraries/contentdm_api', ref: '847a70689813c03990db2ebb622d0beee7657688'
gem 'cdmbl', github: 'Minitex/cdmbl', tag: 'v0.19.0'
gem 'sidekiq', '5.2.7'
gem 'sinatra', '2.0.4', require: false
gem 'sidekiq-failures', '1.0.0'
gem 'whenever', '0.9.7', require: false

# Autmatically link URLs in citation details
gem 'rinku', '2.0.2'
gem 'redis-rails', '5.0.2'

gem 'friendly_id'
gem 'sitemap_generator'
gem 'blacklight-gallery', '>= 0.3.0'
gem 'blacklight-oembed', '~> 0.3'

gem 'autoprefixer-rails', '< 10.0' # Constraint to accommodate Node 8 on QA/Prod
gem 'sentry-raven'
