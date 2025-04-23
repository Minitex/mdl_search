# Deprecation is a dependency of Blacklight, and the Blacklight libraries use it
# to log deprecations. We want to silence them in deployed environments so they
# don't flood the logs.
if Rails.env.production?
  Deprecation.default_deprecation_behavior = :silence
end
