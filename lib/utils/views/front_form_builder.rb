# -*- encoding : utf-8 -*-
require 'simple_form'
require 'nested_form/builder_mixin'

module Utils
  module Views
    class DateTimeInput < SimpleForm::Inputs::DateTimeInput
      def input
        @builder.text_field(attribute_name, input_html_options)
      end
    end
    class FrontFormBuilder < ::SimpleForm::FormBuilder
      include ActionView::Helpers::JavaScriptHelper
      include ActionView::Helpers::TagHelper
      include NestedForm::BuilderMixin

      delegate :concat, :content_tag, :link_to, :link_to_function, :dom_id, :to => :template

      def input(attribute_name, options = {}, &block)
        options[:error_prefix] = '<em></em>'.html_safe
        super(attribute_name, options, &block)
      end

      def attach_file_field(attribute_name, options = {}, &block)
        value = options.delete(:value) if options.key?(:value)
        value ||= object.fileupload_asset(attribute_name)

        element_guid = object.fileupload_guid
        element_id = dom_id(object, [attribute_name, element_guid].join('_'))
        max_size = options[:file_max_size] || object.class.max_size
        script_options = (options.delete(:script) || {}).stringify_keys

        params = {
            :method => attribute_name,
            :assetable_id => object.new_record? ? nil : object.id,
            :assetable_type => object.class.name,
            :guid => element_guid
        }.merge(script_options.delete(:params) || {})

        script_options['action'] ||= '/sunrise/fileupload?' + Rack::Utils.build_query(params)
        script_options['allowedExtensions'] ||= ['jpg', 'jpeg', 'png']
        script_options['multiple'] ||= object.fileupload_multiple?(attribute_name)
        script_options['element'] ||= element_id
        script_options['sizeLimit'] = max_size.megabytes.to_i

        if options[:template_id]
          script_options['template_id'] = options[:template_id]
        end
        if options[:file]
          script_options['allowedExtensions'] ||= []
          script_options['template_id'] = '#fileupload_ftmpl'
          options[:container] = 'fcontainer'
        end
        if options[:video]
          script_options['allowedExtensions'] = ['mp4']
          script_options['template_id'] = '#fileupload_vtmpl'
          options[:asset_render_template] = 'video_file'
          options[:container] = 'container'
        end

        label ||= if object && object.class.respond_to?(:human_attribute_name)
                    object.class.human_attribute_name(attribute_name)
                  end

        locals = {
            :element_id => element_id,
            :file_title => (options[:file_title] || "JPEG, GIF, PNG or TIFF"),
            :file_max_size => max_size,
            :label => (label || attribute_name.to_s.humanize),
            :object => object,
            :attribute_name => attribute_name,
            :assets => [value].flatten.delete_if { |v| v.nil? || v.new_record? },
            :script_options => script_options.inspect.gsub('=>', ':'),
            :multiple => script_options['multiple'],
            :asset_klass => params[:klass],
            :asset_render_template => (options[:asset_render_template] || 'asset')
        }

        container_tmpl = options[:container] || 'container'

        template.render(:partial => "fileupload/#{container_tmpl}", :locals => locals)
      end

    end
  end
end
