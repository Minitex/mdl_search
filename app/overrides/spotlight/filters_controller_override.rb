Spotlight::FiltersController.class_eval do
  def destroy
    @filter.destroy
    redirect_to spotlight.edit_exhibit_path @exhibit, tab: 'filter'
  end
end
