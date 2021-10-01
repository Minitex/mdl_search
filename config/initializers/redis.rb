if Redis.respond_to?(:exists_returns_integer=)
  Redis.exists_returns_integer = true
end
