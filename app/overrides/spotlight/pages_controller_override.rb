###
# Applies changes from
# https://github.com/projectblacklight/spotlight/commit/8ab87c671e7d7e4c0fee8944e1c9eb3957653e2e
# which we can't use otherwise due to dependency conflicts
# with other Blacklight plugins
Spotlight::PagesController.class_eval do
  # POST /exhibits/1/pages
  def create
    @page.attributes = page_params
    @page.last_edited_by = @page.created_by = current_user

    if @page.save
      redirect_to [spotlight, @page.exhibit, page_collection_name.to_sym],
                  notice: t(:'helpers.submit.page.created', model: @page.class.model_name.human.downcase)
    else
      render action: 'new'
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy

    redirect_to [spotlight, @page.exhibit, page_collection_name.to_sym],
                flash: { html_safe: true }, notice: undo_notice(:destroyed)
  end
end
