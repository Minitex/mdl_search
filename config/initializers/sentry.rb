Raven.configure do |config|
  config.excluded_exceptions += [MDL::EtlAuditing::JobNotYetCreatedError]
end
