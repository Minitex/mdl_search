# The Psych YAML loader in Ruby 3.1 is Psych 4, which requires
# callers of `load` to opt-in to aliases. Version 6 of Rails
# doesn't have this patched yet, so we'll just alias it here.
module YamlOverride
  def self.apply
    YAML.module_eval do
      alias_method :load, :unsafe_load if YAML.respond_to? :unsafe_load
    end
  end
end

# YamlOverride.apply
