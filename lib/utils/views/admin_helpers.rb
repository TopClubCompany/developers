# -*- encoding : utf-8 -*-
module Utils
  module Views
    module AdminHelpers

      def admin_form_for(object, *args, &block)
        options = args.extract_options!
        options[:html] ||= {}
        options[:html][:class] ||= 'form-horizontal'
        options[:builder] ||= ::Utils::Views::FormBuilder
        if options.delete(:nested)
          simple_nested_form_for([:admin, object].flatten, *(args << options), &block)
        else
          simple_form_for([:admin, object].flatten, *(args << options), &block)
        end
      end

      def nested_admin_form_for(object, *args, &block)
        options = args.extract_options!
        options[:builder] ||= ::Utils::Views::FormBuilder
        simple_nested_form_for([:admin, object].flatten, *(args << options), &block)
      end

      def link_to_unless_current_span2(name, options = {}, html_options = {}, &block)
        if current_page?(options)
          if block_given?
            block.arity <= 1 ? yield(name) : yield(name, options, html_options)
          else
            content_tag(:span, content_tag(:span, name), html_options)
          end
        else
          link_to(name, options, html_options)
        end
      end

      def options_for_ckeditor(options = {})
        {:width => 800, :height => 200, :toolbar => 'Easy'}.update(options)
      end

      def link_to_sort(title, options = {})
        options.symbolize_keys!

        order_type = options[:order_type] || 'asc'
        order_column = options[:name] || 'id'
        class_name = options[:class] || nil

        search_options = request.params[:search] || {}
        search_options.update(:order_column => order_column, :order_type => order_type)

        link_to(title, :search => search_options, :class => class_name)
      end

      def remove_child_link(name, f)
        f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
      end

      def add_child_link(name, f, method, options={})
        options.symbolize_keys!

        html_options = options.delete(:html) || {}
        fields = new_child_fields(f, method, options)

        html_options[:class] ||= "new"

        content_tag(:div,
                    link_to_function(name, raw("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\")"), html_options),
                    :class=>"add-bl")
      end

      def new_child_fields(form_builder, method, options = {})
        options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
        options[:partial] ||= method.to_s.singularize
        options[:form_builder_local] ||= :form

        form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
          render(:partial => options[:partial], :locals => {options[:form_builder_local] => f})
        end
      end

      def cookie_content_tag(tag_name, options={}, &block)
        key = options[:id]
        options[:style] = "display:none;" if !cookies[key].blank? && cookies[key].to_i != 1
        content_tag(tag_name, options, &block)
      end

      def manage_icon(image, options = {})
        options = {:alt => t(image, :scope => 'manage.icons'), :title => t(image, :scope => 'manage.icons')}.merge(options)
        image_tag("manage/ico_#{image}.gif", options)
      end

    end
  end
end
