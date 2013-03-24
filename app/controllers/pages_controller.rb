class PagesController < ApplicationController

  def show

  end

  def index
    redirect_to root
  end

  def save_cooperation

  end


  private

  def find_page
    @structure ||= Structure.find(params[:id])
    @parent ||= @structure.parent
    @page = @structure.static_page
    @parent_page = @parent.static_page if @parent
    setting_meta_tags @structure
  end

  def set_breadcrumbs_front
    super
    @breadcrumbs_front << ["<a href=#{with_locale(page_path(@structure))}>#{@structure.title}&nbsp</a>"]
  end

end
