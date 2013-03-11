class PagesController < ApplicationController

  def show

  end

  def index
    redirect_to root
  end


  private

  def find_page
    @structure ||= Structure.find(params[:id])
    @page = @structure.static_page
    setting_meta_tags @structure
  end

  def set_breadcrumbs
    super
    @breadcrumbs << ["<a href=#{with_locale(page_path(@structure))}>#{@structure.title}&nbsp</a>"]
  end

end
