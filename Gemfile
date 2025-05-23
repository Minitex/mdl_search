source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test]

gem 'mysql2', '~> 0.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.0'
# # Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# # Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# # See https://github.com/rails/execjs#readme for more supported runtimes
gem 'execjs'
# # Use jquery as the JavaScript library
gem 'jquery-rails'
# # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'bootstrap', '~> 4.0'
gem 'bootstrap_form', '~> 4.0'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  gem 'binding_of_caller'
  gem 'fontello_rails_converter'
  gem 'coveralls', require: false
end

group :test, :development do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
  gem 'shoulda-matchers'
end

gem 'blacklight', '~> 7.27'
gem 'blacklight_advanced_search', '~> 7.0'
gem 'blacklight_range_limit', '~> 8.2.0'
gem 'blacklight-spotlight', '~> 4.0'
gem 'blacklight_oai_provider', '~> 7.0'
gem 'blacklight-gallery', '>= 0.3.0'
gem 'blacklight-oembed', '~> 1.1'

gem 'view_component', '< 3'

gem 'chosen-rails', '~> 1.9'
gem 'leaflet-rails'
gem 'rsolr', '~> 2.5'
gem 'globalid', '~> 1.0'
gem 'webpacker', '~> 5.4'
gem 'cancancan', '~> 3.4'

# # CONTENTdm ETL
gem 'devise', '~> 4.8'
gem 'contentdm_api', '~> 0.6'
gem 'cdmbl', github: 'Minitex/cdmbl', ref: '68e154c'
gem 'sidekiq', '< 8'
gem 'sinatra', '~> 2.0', require: false
gem 'sidekiq-failures', '~> 1.0'
gem 'whenever', '~> 0.9', require: false
gem 'async'
gem 'async-http'
gem 'thread-local'
gem 'rubyzip'
gem 'aws-sdk-s3', '~> 1.114'
gem 'json', '~> 2.6', '>= 2.6.2'

# Autmatically link URLs in citation details
gem 'rinku', '~> 2.0'
gem 'redis-rails', '~> 5.0'

gem 'friendly_id'
gem 'sitemap_generator'

gem 'autoprefixer-rails', '~> 10.4.7' # Constraint to accommodate Node 8 on QA/Prod
gem 'kaltura-client'

gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'
