# -*- encoding : utf-8 -*-
module Utils
  module Controllers
    module Application
      extend ActiveSupport::Concern

      module ClassMethods
        def self.extended(base)
          base.class_eval do
            protect_from_forgery
            #before_filter :set_locale
            #  before_filter lambda { Rails.logger.warn cookies.inspect; Rails.logger.warn session.inspect }
            helper_method :admin?, :current_ability, :current_structure

            respond_to :html, :xml, :json

            if Rails.env.production?
              rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, :with => :render_404
            else
              rescue_from ActiveRecord::RecordInvalid, :with => :show_errors
            end

            rescue_from CanCan::AccessDenied do |exception|
              redirect_to new_user_session_path, :alert => exception.message
            end

            #rescue_from CanCan::AccessDenied do |exception|
            #  flash[:error] = I18n.t(:access_denied, :scope => [:flash, :users])
            #  redirect_to root_url
            #end
          end
        end
      end

      #protected
      #
      #def set_locale
      #  if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) && !request.xhr?
      #    I18n.locale = params[:locale].to_sym
      #  end
      #end
      #
      #def default_url_options
      #  {:locale => (I18n.locale == I18n.default_locale ? nil : I18n.locale)}
      #end

      def xhr?
        request.xhr?
      end

      def current_structure
        return nil unless params[:structure_id]
        @structure ||= Structure.visible.find(params[:structure_id])
      end

      def get_resource(scope, r_id=params[:id])
        scope.find(r_id)
      rescue => e
        #content_manager? ? scope.unscoped.find(r_id) : raise(e)
      end

      def set_rc(obj, options={})
        obj_rc = obj ? {:subject_id => obj.id, :subject_type => obj.class.name} : {}
        gon.rc = obj_rc.update(options)
      end

      def render_404
        respond_to do |type|
          type.html { redirect_to root_url }
          type.all { render :nothing => true, :status => "404 Not Found" }
        end
      end

      def redirect_back_or_root(opts = {})
        if request.env["HTTP_REFERER"]
          redirect_to :back, opts
        else
          redirect_to :root, opts
        end
      end


      def admin?
        user_signed_in? && current_user.admin?
      end

      def show_errors(e)
        I18n.with_locale(:en) do
          e.record.valid?
          raise e.record.errors.full_messages.join("\n        ")
        end
      end

      def i18n_flash_scope
        [:flash, controller_name, action_name]
      end

      def i18n_admin_flash_scope
        [:flash, :admin, controller_name, action_name]
      end

    end
  end
end
