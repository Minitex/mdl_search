module Spotlight
  module HomePagesControllerOverride
    def self.apply
      Spotlight::HomePagesController.class_eval do
        include BlacklightRangeLimit::ControllerOverride
      end
    end
  end
end

Spotlight::HomePagesControllerOverride.apply
