class Admin::LocatorsController < Admin::BaseController
  load_and_authorize_resource


  #before_filter :find_locators, :only => [:index, :edit, :update]
  #before_filter :find_locator, :only => [:edit, :update]

  def edit
    @main_locale_hash = @i18n_back.get_main_by_file(params[:id].to_i, params[:keys])
    @locale_hash = @i18n_back.get_by_file(params[:id].to_i, params[:keys])
  end

  def update
    if @i18n_back.set_by_file(params[:id].to_i, params[:locale_hash])
      flash[:notice] = I18n.t('flash.admin.locators.updated')
      redirect_to admin_locators_path
    else
      flash[:error] = I18n.t('flash.admin.locators.update_error')
      redirect_to edit_admin_locator_path(:id => params[:id])
    end
  end

  def prepare
    @i18n_back = Utils::I18none::Translator.prepare_from_env
    if @i18n_back.message
      flash[:error] = @i18n_back.message
    else
      flash[:notice] = I18n.t('flash.admin.locators.prepared')
    end
    redirect_to collection_path
  end

  def reload
    I18n.reload!
    flash[:notice] = I18n.t('flash.admin.locators.restart')
    redirect_to collection_path
  end

  def cache_clear
    Utils::Base::Files.clear_cache
    redirect_to collection_path, flash: { notice: "successfully cleared cache" }
  end


  protected

  def collection
    []
  end

  def settings
    {:index_view => 'table', :well => true}
  end

  def action_items
    []
  end

  def find_locators
    @i18n_back = Utils::I18none::Translator.from_env
    @locators = {}
    @i18n_back.locale_files.each_with_index { |f, i| @locators[f.locale] ||= []; @locators[f.locale] << [f.file.sub(Rails.root.to_s, ''), i] }
  end

  def find_locator
    unless @locator = @i18n_back.locale_files[params[:id].to_i]
      flash[:error] = 'No file found'
      redirect_back_or_root
    end
  end

  def add_breadcrumbs
    []
  end

end
