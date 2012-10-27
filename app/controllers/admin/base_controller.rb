class Admin::BaseController < ::InheritedResources::Base
  include Utils::Controllers::Callbacks

  before_filter :authenticate_user!
  before_filter :check_admin, :unless => :admin?
  before_filter :add_breadcrumbs, :set_title, :set_user_vars, :unless => :xhr?

  class_attribute :csv_builder

  custom_actions :collection => :search

  has_scope :ids, :type => :array

  helper_method :button_scopes, :collection_action?, :action_items, :index_actions, :csv_builder,
                :preview_resource_path, :get_subject, :settings, :with_sidebar?

  define_admin_callbacks :save, :create

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_root_path, :alert => exception.message
  end

  #load_and_authorize_resource

  layout :set_layout

  def index
    super do |format|
      format.csv do
        headers['Content-Type'] = 'text/csv; charset=utf-8'
        headers['Content-Disposition'] = %{attachment; filename="#{csv_filename}"}
      end
    end
  end

  def create
    create! do |success, failure|
      success.html { redirect_to redirect_to_on_success }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to redirect_to_on_success }
      failure.html { render :edit }
    end
  end

  def destroy
    destroy! { redirect_to_on_success }
  end

  def batch
    raise 'no ids' unless params[:ids].present?
    action = resource_class.batch_action(params[:batch_action])
    if collection.all?{|item| can?(action, item) }
      count = collection.inject(0) { |c, item| item.send(action) ? c + 1 : c }
      flash[:success] = "#{count} #{action}"
    else
      flash[:failure] = "no permissions"
    end
    redirect_to :back
  end

  def search
    collection
    render :index
  end

  def self.csv(options={}, &block)
    self.csv_builder = ::Utils::CSVTools::CSVBuilder.new(options, &block)
  end

  protected

  def with_sidebar?
    collection_action? && settings[:sidebar]
  end

  def self.inherited(base)
    super
    base.class_eval do
      before_create :bind_current_user
    end
  end

  def csv_filename
    "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.csv"
  end

  def csv_builder
    self.class.csv_builder || ::Utils::CSVTools::CSVBuilder.default_for_resource(resource_class)
  end

  def set_title
    lookups = [:"admin.#{controller_name}.actions.#{action_name}.title",
               :"admin.#{controller_name}.actions.#{action_name}",
               :"admin.actions.#{action_name}.title",
               :"admin.actions.#{action_name}"]
    @page_title ||= [resource_class.model_name.human(:count => 9), t(lookups.shift, :default => lookups)].join(' - ')
  end

  def preview_resource_path(item)
    nil
  end

  def settings
    {:index_view => 'table', :sidebar => true, :well => true, :search => true, :batch => true}
  end

  def action_items
    case action_name.to_sym
      when :new, :create
        [:new]
      when :show
        [:new, :edit, :destroy]
      when :edit, :update
        [:new, :show, :destroy]
      when :index
        [:new]
      else
        [:new]
    end
  end

  def index_actions
    [:edit, :destroy, :show, :preview]
  end

  def collection_action?
    #!request.path_parameters[:id] && action_name
    ['index', 'search', 'batch'].include?(action_name)
  end

  def with_sidebar?
    collection_action?
  end

  def button_scopes
    @@button_scopes ||= begin
      res = {}
      self.class.scopes_configuration.except(:ids).each do |k, v|
        res[k] = v if v[:type] == :default
      end
      res
    end
  end

  def add_breadcrumbs
    @breadcrumbs = []
    if parent?
      @breadcrumbs << {:name => parent_class.model_name.human(:count => 9),
                       :url => {:action => :index, :controller => "admin/#{parent_class.model_name.plural}"}}
      @breadcrumbs << {:name => parent.title, :url => parent_path}
    end
    @breadcrumbs << {:name => resource_class.model_name.human(:count => 9), :url => collection_path}
    if params[:id]
      @breadcrumbs << {:name => resource.title, :url => resource_path}
    end
  end

  def collection
    @search = end_of_association_chain.accessible_by(current_ability).admin.ransack(params[:q] || {:s => 'id desc'})
    @search.result(:distinct => true).paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def set_layout
    "admin/#{request.headers['X-PJAX'] ? 'pjax' : 'application'}"
  end

  def back_or_collection
    if params[:return_to].present? && (params[:return_to] != request.fullpath)
      params[:return_to]
    else
      smart_collection_url
    end
  end

  def redirect_to_on_success
    if params[:_add_another]
      new_resource_path(:return_to => params[:return_to])
    elsif params[:_add_edit]
      edit_resource_path(:id => resource.id, :return_to => params[:return_to])
    else
      back_or_collection
    end
  end

  def set_user_vars
    I18n.locale = Rails.application.config.i18n.default_locale
    #gon.bg_color = current_user.bg_color
  end

  def check_admin
    redirect_to user_signed_in? ? root_path : new_user_session_path
  end

  def admin?
    current_user.admin?
  end

  def bind_current_user(*args)
    resource.user_id = current_user.id if resource.respond_to?(:user_id)
  end

  def xhr?
    request.xhr?
  end

  # roles logic
  def role_given?
    fetch_role
  end

  def as_role
    {:as => fetch_role}
  end

  def get_role
    nil
  end

  def fetch_role
    @as_role ||= get_role
  end

  def get_subject
    params[:id] ? resource : resource_class
  end

end