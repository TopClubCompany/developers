class PagesController < ApplicationController

  def show

  end

  def index
    redirect_to root
  end

  def save_cooperation
    cooperation = Cooperation.new(params[:cooperation])
    if cooperation.save
      flash = {notice: I18n.t('cooperation.notice')}
      AccountMailer.new_cooperation(Figaro.env.COOPERATION_EMAIL, "cooperation", admin_cooperation_url(cooperation)).deliver
    else
      flash = {error: I18n.t('cooperation.error')}
    end
    redirect_to :back, flash: flash
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
