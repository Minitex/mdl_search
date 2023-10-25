Raven.configure do |config|
  config.excluded_exceptions += [
    MDL::EtlAuditing::JobNotYetCreatedError,
    Blacklight::Exceptions::RecordNotFound
  ]
end
