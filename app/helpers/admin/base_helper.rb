# -*- encoding : utf-8 -*-
module Admin::BaseHelper
  def admin_comments
    render 'admin/admin_comments/comments'
  end

  def color_bool(val, success_class='badge-success')
    %(<span class="badge #{success_class if val}">#{val ? '+' : '-'}</span>).html_safe
  end

  def pagination_info(c)
    offset = c.offset
    per_page = (params[:per_page] || resource_class.per_page).to_i
    total_entries = c.total_entries
    t('will_paginate.pagination_info', :from => offset + 1, :to => [offset + per_page, total_entries].min, :count => total_entries).html_safe
  end

  def ha(attr)
    resource_class.han(attr)
  end

  def item_img(item, assoc=:photo, size=:thumb)
    image_tag_if(item.send(assoc).try(:url, size))
  end

  def text_addon(text)
    %(<span class="add-on">#{text}</span>).html_safe
  end

  def icon_addon(name)
    text_addon(%(<i class="icon-#{name}"></i>))
  end

  def call_method_or_proc_on(obj, symbol_or_proc, options = {})
    exec = options[:exec].nil? ? true : options[:exec]
    case symbol_or_proc
      when Symbol, String
        obj.send(symbol_or_proc.to_sym)
      when Proc
        if exec
          instance_exec(obj, &symbol_or_proc)
        else
          symbol_or_proc.call(obj)
        end
    end
  end

  def admin_menu_link(model)
    content_tag :li, :class => ('active' if controller_name.split('/').last == model.model_name.plural) do
      link_to model.model_name.human(:count => 9), "/admin/#{model.model_name.plural}"
      #link_to model.model_name.human(:count => 9), {:action => :index, :controller => "admin/#{model.model_name.plural}"}
    end
  end

  def admin_menu_link_without_model(name, path, path_name)
    content_tag :li, :class => ('active' if path_name == request.url.split('/').last) do
      link_to name, path
      #link_to model.model_name.human(:count => 9), {:action => :index, :controller => "admin/#{model.model_name.plural}"}
    end
  end

  def item_index_actions(item)
    index_actions.map do |act|
      short_action_link(act, item)
    end.join(' ').html_safe
  end

  def id_link(item, edit=true)
    if can?(:edit, item) && edit
      link_to item.id, edit_resource_path(item), :class => 'resource_id_link'
    elsif can? :read, item
      link_to item.id, resource_path(item), :class => 'resource_id_link'
    else
      item.id
    end
  end

  def batch_action_toggle
    if settings[:batch]
      content_tag :th do
        check_box_tag '', '', false, :id => nil, :class => 'toggle'
      end
    end
  end

  def batch_action_item(item)
    if settings[:batch]
      content_tag :td do
        check_box_tag 'ids[]', item.id, false, :id => "batch_action_item_#{item.id}"
      end
    end
  end

  def link_to_can?(act, *args, &block)
    item_link_to_can?(act, get_subject, *args, &block)
  end

  def item_link_to_can?(act, item, *args, &block)
    #if controller.action_methods.include?(act.to_s) && can?(act, get_subject)
    if can?(act, get_subject)
      if block_given?
        link_to(*args, &block)
      else
        link_to(*args)
      end
    end
  end

  def short_action_link(action, item)
    case action
      when :new
        item_link_to_can? :create, item, t("admin.actions.new.link"), new_resource_path,
                          :class => 'btn btn-primary'
      when :edit
        item_link_to_can? :update, item, icon('pencil', true), edit_resource_path(item),
                          :class => 'btn btn-primary', :title => t('admin.actions.edit.link')
      when :destroy
        item_link_to_can? :destroy, item, icon('trash', true), resource_path(item),
                          :method => :delete, :data => {:confirm => t('admin.delete_confirmation')},
                          :class => 'btn btn-danger', :title => t('admin.actions.destroy.link')
      when :show
        item_link_to_can? :show, item, icon('info-sign', true), resource_path(item),
                          :class => 'btn btn-info', :title => t('admin.actions.show.link')
      when :perms
        item_link_to_can? :edit, item, icon('cog', true), perms_admin_role_path(item), :class => 'btn btn-success'
      when :preview
        if preview_resource_path(item)
          link_to icon('eye-open', true), preview_resource_path(item),
                  :class => 'btn btn-small btn-inverse', :title => t('admin.actions.preview.link'), :target => '_blank'
        end
      else
        meth = "#{resource_instance_name}_short_action_link"
        send(meth, action, item) if respond_to? meth
    end
  end

  def action_link(action)
    case action
      when :new
        link_to_can? :create, t("admin.actions.new.link"), new_resource_path, :class => 'btn btn-primary'
      when :edit
        link_to_can? :update, t("admin.actions.edit.link"), edit_resource_path, :class => 'btn btn-primary'
      when :destroy
        link_to_can? :destroy, t("admin.actions.destroy.link"), resource_path, :method => :delete, :data => {:confirm => t('admin.delete_confirmation')},
                     :class => 'btn btn-danger'
      when :show
        link_to_can? :show, t("admin.actions.show.link"), resource_path, :class => 'btn btn-info'
      when :preview
        if preview_resource_path(resource)
          link_to t("admin.actions.preview.link"), preview_resource_path(resource), :class => 'btn btn-inverse', :title => t('admin.actions.preview.link'), :target => '_blank'
        end
      when :perms
        link_to_can? :edit, t("admin.actions.perms.link"), perms_admin_role_path(resource), :class => 'btn btn-success'
      else
        meth = "#{resource_instance_name}_action_link"
        send(meth, action) if respond_to? meth
    end
  end

  def sort_link(search, attribute, *args)
    search_params = params[:q] || {}.with_indifferent_access
    attr_name = attribute.to_s
    name = resource_class.han(attribute)

    if existing_sort = search.sorts.detect { |s| s.name == attr_name }
      prev_attr, prev_dir = existing_sort.name, existing_sort.dir
    end

    options = args.first.is_a?(Hash) ? args.shift.dup : {}
    default_order = options.delete :default_order
    current_dir = prev_attr == attr_name ? prev_dir : nil

    if current_dir
      new_dir = current_dir == 'desc' ? 'asc' : 'desc'
    else
      new_dir = default_order || 'asc'
    end

    html_options = args.first.is_a?(Hash) ? args.shift.dup : {}
    css = ['sort_link', current_dir].compact.join(' ')
    html_options[:class] = [css, html_options[:class]].compact.join(' ')
    options.merge!(:q => search_params.merge(:s => "#{attr_name} #{new_dir}"))

    link_to [name, order_indicator_for(current_dir)].compact.join(' ').html_safe, url_for(options), html_options
  end

  def order_indicator_for(order)
    if order == 'asc'
      '&#9650;'
    elsif order == 'desc'
      '&#9660;'
    else
      '<span class="order_indicator">&#9650;&#9660;</div></span>'
    end
  end

  def search_admin_form_for(object, *args, &block)
    params[:q] ||= {}
    options = args.extract_options!
    options[:html] ||= {}
    options[:html][:id] ||= 'search_form'
    options[:html][:class] ||= 'pjax-form'
    options[:builder] ||= ::Utils::Views::SearchFormBuilder
    options[:method] ||= :get
    form_for([:admin, object].flatten, *(args << options), &block)
  end

  def icon(name, white=false)
    "<i class='icon-#{name} #{'icon-white' if white}'></i> ".html_safe
  end

  # input_set r('admin.pictures'), :legend_class => 'do_sort', :label_class => 'label-info' do
  def input_set(title, options={}, &block)
    options.reverse_merge!(:class => "inputs well well-small #{options.delete(:legend_class) || 'do_sort'}", :id => options.delete(:legend_id))
    html = content_tag(:label, title, :class => "input_set label #{options.delete(:label_class)}")
    html.concat(capture(&block)) if block_given?
    content_tag(:fieldset, html, options)
  end

  # == old ===

  def cached_by_class(klass, prefix=nil, &block)
    prefix ||= "cached_by_class_#{klass.name}"
    Rails.cache.fetch("#{prefix}_#{klass.max_time}", &block)
  end

  def cached_nested_options(klass)
    cached_by_class(klass, 'nested_set_options') do
      scoped_nested_set_options(klass.includes(:translations)) { |i| "#{'–' * i.depth} #{i.title}" }
    end
  end

  def add_for_token(model, url=nil)
    url ||= "/admin/#{model.model_name.plural}"
    can?(:create, model, :context => :admin) ? {"data-add" => url} : {}
  end

  def geo_input(prefix, &block)
    content_tag :div, :class => 'geo_input' do
      map_js = "$(function(){initGeoInput(#{prefix.inspect})})"
      ''.tap do |out|
        out << javascript_include_tag("//maps.googleapis.com/maps/api/js?sensor=false&libraries=places&language=#{I18n.locale}")
        out << label_tag(:geo_autocomplete, t('admin.geo_autocomplete'))
        out << text_field_tag("#{prefix}_geo_autocomplete")
        out.concat(capture(&block)) if block_given?
        out << content_tag(:div, '', :class => 'admin_map', :id => "#{prefix}_map")
        out << javascript_tag(map_js)
      end.html_safe
    end
  end
  def front_geo_input(prefix, &block)
    content_tag :div, :class => 'geo_input' do
      map_js = "$(function(){initGeoInput(#{prefix.inspect})})"
      ''.tap do |out|
        out << javascript_include_tag("//maps.googleapis.com/maps/api/js?sensor=false&libraries=places&language=#{I18n.locale}")
        out << "<div class='map_input'>"
        out << label_tag(:geo_autocomplete, t('admin.geo_autocomplete'))
        out << text_field_tag("#{prefix}_geo_autocomplete")
        out << "</div>"
        out.concat(capture(&block)) if block_given?
        out << content_tag(:div, '', :class => 'admin_map', :id => "#{prefix}_map")
        out << javascript_tag(map_js)
      end.html_safe
    end
  end

  def admin_edit_link(rec, opts = {})
    return '' unless rec
    html_options = opts.delete(:html_options) || {}
    rec_title = opts.delete(:title) || rec.title
    opts.reverse_merge!({controller: rec.class.model_name.plural, action: :edit, id: rec.id})
    link_to rec_title, opts, html_options
  end

  def auto_edit_link(rec, opts = {})
    return '' unless rec
    html_options = opts.delete(:html_options) || {}
    rec_title = opts.delete(:title) || rec.title
    opts.reverse_merge!({controller: rec.class.model_name.plural, action: :edit, id: rec.id})
    link_to_if can?(:edit, rec), rec_title, opts, html_options
  end

  def auto_show_link(rec, opts = {})
    return '' unless rec
    opts.reverse_merge!({controller: rec.class.name.underscore.pluralize, action: :show, id: rec.id})
    link_to_if can?(:read, rec, :context => :admin), rec.title, url_for(opts)
  end

  def photo_thumb(r, image_assoc=:photo, type=:thumb)
    image = r.send(image_assoc)
    image ? image_tag(image.url(type)) : ''
  end

  def nested_inputs(locale_hash, keys=[], options={})
    options.reverse_merge!({:is_media => false, :prefix => 'locale_hash'})
    locale_hash.map do |k, v|
      if v.is_a?(Hash)
        content_tag(:div, label_tag(k)+tag(:br)+nested_inputs(v, [keys, k].flatten, options), :class => 'nested_inputs')
      else
        name = "#{options[:prefix]}#{keys_to_str(keys+[k])}"
        content_tag(:div, :class => 'nested_inputs') do
          ''.tap do |out|
            out << content_tag(:div, :class => 'block') do
              label_tag(k) + tag(:br)
            end

            if options[:is_media]
              out << cktext_area_tag(name, v, :height => 350, :width => 600, :toolbar => 'VeryEasy')
            else
              out << content_tag(:div, text_area_tag(name, v, :size => '65x2'), :class => 'textarea_wrap')
            end
          end.html_safe
        end
      end
    end.join.html_safe
  end

  def keys_to_str(keys)
    keys.inject('') { |res, key| res << "[#{key}]" }
  end








  def node_path(node)
    case node
      when Structure
        edit_structure_record_path(node)
      else
        '#'
    end
  end

end
