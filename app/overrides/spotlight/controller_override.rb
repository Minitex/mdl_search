module Spotlight
  module ControllerOverride
    def search_facet_path(*args, **kwargs)
      if current_exhibit
        exhibit_search_facet_path(*args, **kwargs)
      else
        opts = search_state
           .to_h
           .merge(only_path: true)
           .merge(kwargs)
           .except(:page)
        main_app.facet_catalog_url(*args, **opts)
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

Spotlight::Controller.prepend(Spotlight::ControllerOverride)
