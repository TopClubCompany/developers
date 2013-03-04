# -*- encoding : utf-8 -*-
module ApplicationHelper

  def get_reg_form_attr_name(attr, require = nil)
    validator = ActiveModel::Validations::PresenceValidator
    attr_name = User.han(attr) + ':'
    User.validators_on(attr.to_sym).each { |v| require = true if v.is_a? validator } if require.nil?
    require ? attr_name + (content_tag :b,'*') : attr_name
  end

  def rand_str
    Rails.env.development? ? rand(9999) : ''
  end

  def remote_image_if(image, options={})
    return unless image
    image_tag "//#{options[:host] || 'www.top_club.com'}/#{image}", options
  end

  def image_tag_if(image, options={})
    return unless image
    image_tag image, options
  end

  def truncate_text(html, size=200)
    return '' unless html
    truncate(html.gsub(/&quot;|&laquo;|&raquo;/, "'").gsub(/&mdash;/, '-').no_html.squish, :length => size, :separator => ' ')
  end

  def truncate_content(html, size=200)
    return '' unless html
    truncate_html(html, :length => size).html_safe
  end

  def external_link(raw_link, options={}, &block)
    options.reverse_merge!(:title => raw_link, :target => '_blank', :rel => 'nofollow')
    link = raw_link =~ /^http[s]?:\/\// ? raw_link : "http://#{raw_link}"
    if block_given?
      link_to link, options, &block
    else
      link_to options[:title], link, options
    end
  end

  def locale_path
    I18n.locale == I18n.default_locale ? '' : "/#{I18n.locale}"
  end

  def with_local_link link
    locale_path + link
  end

  def front_form_for(object, *args, &block)
    options = args.extract_options!
    options[:builder] ||= ::Utils::Views::FrontFormBuilder
    options[:wrapper] ||= :default
    simple_form_for(object, *(args << options), &block)
  end

  def current_section?(item, struct = @structure)
    unless struct.nil?
      item.self_and_descendants.include?(struct)
    end
  end

  def image_full_url(path)
    "#{request.protocol}#{request.host_with_port}#{path}"
  end

  def back_link
    if session['back_link']
      ''.tap do |out|
        out << link_to(t('back'), session['back_link'])
        out << ' '
        out << image_tag("/images/back.png")
      end.html_safe
    end
  end

  def weekday_names
    I18n.t('date.abbr_day_names').dup.tap { |a| a << a.shift }.map { |n| n.sub(/\.$/, '') }
  end

  def as_html(text)
    return '' if text.nil?
    Nokogiri::HTML.fragment(text).to_html.html_safe
  end

  def to_human(raw_model_class, method)
    model_class = case raw_model_class
                    when Symbol, String
                      raw_model_class.to_s.camelcase.constantize
                    when Class
                      raw_model_class
                  end
    if model_class.respond_to?(:human_attribute_name)
      model_class.human_attribute_name(method)
    else
      method.to_s.titlecase
    end
  end

  def mail_property(record, property)
    case property
      when Array
        property.map { |p| mail_property(record, p) }.join("\n").html_safe
      when String, Symbol
        mail_string(to_human(record.class, property), pretty_data(record.send(property)))
    end
  end

  def mail_string(attr, val)
    "<p><strong>#{attr}: </strong>#{val}</p>".html_safe
  end

  def pretty_data(val)
    case val
      when TrueClass
        '+'
      when FalseClass #, NilClass
        '-'
      when Data, DateTime, Time, ActiveSupport::TimeWithZone
        I18n.l(val, :format => :long)
      when String, Integer
        val
      else
        val.respond_to?(:title) ? val.title : val
    end
  end

  def content_manager?
    user_signed_in? && current_user.content_manager?
  end

  def admin?
    user_signed_in? && current_user.admin?
  end

  def link_to_unless_locale(locale, name, options = {}, html_options = {})
    unless I18n.locale == locale.to_sym
      link_to(name, options, html_options)
    else
      content_tag(:span, name, html_options)
    end
  end


  def with_ability(*args)
    raw_model_class = args.shift
    model_class = case raw_model_class
                    when Symbol, String
                      raw_model_class.to_s.camelcase.constantize
                    else
                      raw_model_class
                  end
    return raw_model_class.scoped if $no_devise
    args.unshift(current_ability)
    model_class.accessible_by(*args)
  end

  def og_tags(options=@og_tags)
    options ||= {}
    options.reverse_merge!({
                               #'fb:app_id' => configatron.facebook.app_id,
                               'og:title' => t('facebook.og.title'),
                               'og:type' => t('facebook.og.type'),
                               'og:image' => t('facebook.og.image'),
                               'og:url' => t('facebook.og.url'),
                               'og:description' => t('facebook.og.description'),
                               'og:site_name' => t('facebook.og.site_name')
                           })

    options.map { |k, v| tag(:meta, :content => v, :property => k) }.join("\n").html_safe
  end

  def like_button(options={})
    options = {'data-href' => request.url, "data-send" => "true",
               "data-width" => "450", "data-show-faces" => "true",
               "class" => 'fb-like'}.update(options)
    content_tag(:div, '', options)
  end

  def alphavit
    html = ''
    ::Utils::I18none::Alphavit.init.each do |char|
      html << (link_to char, '#', {class: 'char', "data-id" => char})
    end
    html
  end

  def menu_href(type)
    href = case type
             when 2
               "#{locale_path}/posts"
             when 6
               "#{locale_path}/search"
             else
               '#'
           end
  end



  def user_liked?(obj, type = "")
    current_user.user_footmarks.with_subject_and_id(type, obj.id).count > 0
  end

  def liked_class(obj, type = "")
    return 'not_login' unless current_user
    if user_liked?(obj, type)
      'liked'
    else
      ''
    end
  end

  def file_icon_class(content_type)
    MIME::Type.new(content_type).try(:sub_type)
  end

  def locale_class(locale)
    if I18n.locale.to_s == locale.to_s
      "active"
    else
      ""
    end
  end

  def get_city_class city
    if current_city == city
      'active'
    end
  end


  def time_with_locale(time)
    minutes = '00' if time[:m] == '15'
    minutes = '30' if time[:m] == '45'
    minutes = (minutes || time[:m])
    if I18n.locale.to_s == "en"
      time_no_quarters = Time.parse(time[:h] + ':' + minutes).strftime("%l:%M %p").sub( /^\s/, '')
      en_time(time_no_quarters)
    else
      time_no_quarters =  Time.parse(time[:h] + ':' + minutes).strftime("%k:%M").sub( /^\s/, '')
      other_time(time_no_quarters)
    end
  end

  def other_time time_string_to_obtain, format_string =  "%k:%M"
    times = []
    dummy_time = Time.new("0:00")
    48.times do |shift|
      key = (dummy_time + (shift * 30).minutes).strftime(format_string).sub( /^\s/, '')
      if key == time_string_to_obtain
        times.push({key => true})
      else
        times.push({key => false})
      end
    end
    times
  end

  def en_time time_string_to_obtain
    other_time time_string_to_obtain, "%l:%M %p"
  end

  def localization_link(resource)
    "/#{I18n.locale}/#{resource}"
  end

  def addcustomjs(*files)
    javascript_include_tag(*files)
  end

end
