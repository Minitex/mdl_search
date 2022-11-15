# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  :cookie_store,
  key: '_mdl_search_session',
  domain: :all,
  same_site: :none,
  secure: true,
  expire_after: 14.days,
  tld_length: 2
)
