module Spotlight
  module ControllerOverride
    def self.apply
      Spotlight::Controller.module_eval do
        def search_facet_path(*args, **kwargs)
          if current_exhibit
            exhibit_search_facet_path(*args, **kwargs)
          else
            main_app.facet_catalog_url(*args, **kwargs)
          end
        end

        ###
        # Spotlight seems to want to use this to generate a URL
        # to the engine's mount path, but it ends up erroring
        # inside the library with
        #   ActionController::UrlGenerationError
        #   No route matches {:action=>"index", :controller=>"catalog", :locale=>nil}
        def root_url
          url_for(Rails.application.config.spotlight_mount_path)
        end
      end
    end
  end
end

Spotlight::ControllerOverride.apply
