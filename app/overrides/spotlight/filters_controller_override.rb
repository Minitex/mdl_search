module Spotlight
  module FiltersControllerOverride
    def destroy
      @filter.destroy
      redirect_to spotlight.edit_exhibit_path @exhibit, tab: 'filter'
    end
  end
end

Spotlight::FiltersController.prepend(
  Spotlight::FiltersControllerOverride
)
