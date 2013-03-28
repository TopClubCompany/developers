class ApplicationController < ActionController::Base
  protect_from_forgery except: [:save_cooperation]

  before_filter :set_locale
  before_filter :current_city
  before_filter :set_time
  before_filter :set_user_location
  before_filter :find_page, except: [:save_cooperation]
  before_filter :set_gon_current_user
  before_filter :set_user_path
  before_filter :set_breadcrumbs_front, only: [:index, :show]

  helper_method :current_city, :current_city_plural

  protected

    def current_city param=:slug
      current_user.try(:city).try(param) ||  session[:city] || 'kyiv'
    end

    def current_city_plural name = :plural_name
      City.find(current_city).send(name)
    end

    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) #&& !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end

  def set_user_location
    @user_location = cookies[:current_point].try(:split,',')
    if @user_location.present?
      @user_location.map(&:strip)
    else
      @user_location = ["50.451118","30.522301"]
    end
  end

  def set_time
    h,m = params[:reserve_time].try(:split,':')
    @next_day = false
    unless h and m
      now_time = DateTime.now.strftime("%H.%M").to_f
      if now_time >= 22.30
        @next_day = true
      end
      h,m = (DateTime.now + (90 - DateTime.now.min % 15).minutes).strftime("%k:%M").split(':')
    end
    @time = {:h => h.to_s, :m => m.to_s }
  end

  def find_page
    structure = Structure.with_position(::PositionType.index).first
    setting_meta_tags structure
  end

  def setting_meta_tags struct, hash={}
    if struct
      struct.headers.each do |header|
        tag_type = header.tag_type.code.to_sym
        case tag_type
          when :open_graph
            if header.og_tag
              set_meta_tags :open_graph => {
                  :title => merge_meta_tag(header.og_tag.title, hash),
                  :type  => header.og_tag.og_type.to_sym,
                  :url   => merge_meta_tag(header.og_tag.url, hash),
                  :image =>  merge_meta_tag(header.og_tag.image, hash),
                  :site_name =>  merge_meta_tag(header.og_tag.site_name, hash),
                  :description =>  merge_meta_tag(header.og_tag.description, hash)
              }
            end
          when :keywords
            set_meta_tags  tag_type => merge_meta_tag(header.content, hash).split(',')
          else
            set_meta_tags tag_type => merge_meta_tag(header.content, hash)
        end
      end
    end
  end

  def set_gon_current_user
    gon.current_user = current_user if current_user
  end

  def set_user_path
    if !current_user && !request.env['PATH_INFO'].to_s.include?("user_registration")  &&  !request.env['PATH_INFO'].to_s.include?("/users/") && !request.env['PATH_INFO'].to_s.include?("set_unset_favorite_place")
      if I18n.locale.to_sym != I18n.default_locale.to_sym
        session[:return_path] = "/" + I18n.locale.to_s + request.env['PATH_INFO']
      else
        session[:return_path] = request.env['PATH_INFO']
      end
    end
  end


  def signed_in_root_path(resource_or_scope)
    session[:return_path] || root_path
  end

  def set_breadcrumbs_front
    @breadcrumbs_front = ["<a href=#{with_locale("")}>#{I18n.t('breadcrumbs.main')}&nbsp</a>"]
  end

  def with_locale(path)
    path = "/" + path if path[0] != "/"
    if I18n.locale.to_sym == :ru
      path
    else
      "/" + I18n.locale.to_s + path
    end
  end

  private

  def merge_meta_tag(tag, hash={})
    hash.each do |key, value|
      tag = tag.gsub("{#{key.to_s}}", value.to_s) if tag.present?
    end
    tag
  end

end
