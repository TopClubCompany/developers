class Admin::RolesController < Admin::BaseController
  load_and_authorize_resource

  optional_belongs_to :group

  def perms

  end

  def update_perms
    if resource.update_permissions(params[:role])
      flash[:notice] = I18n.t('flash.admin.permissions.success')
    else
      flash[:error] = I18n.t('flash.admin.permissions.failure')
    end

    redirect_to :back
  end


  private

  def action_items
    case action_name.to_sym
      when :show
        [:new, :edit, :destroy, :perms]
      when :edit, :update
        [:new, :show, :destroy, :perms]
      else
        super
    end
  end

  def index_actions
    [:edit, :destroy, :show, :perms]
  end


end
