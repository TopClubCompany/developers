module ActiveSupport
  class OrderedHash < ::Hash
    def to_yaml(opts = {})
      YAML::quick_emit(self, opts) do |out|
        out.map(nil, to_yaml_style) do |map|
          each do |k, v|
            map.add(k, v)
          end
        end
      end
    end
  end
end

module SimpleForm
  module Components
    module Wrapper
      def wrap(content)
        if options[:legend]
          template.content_tag(:fieldset, content, wrapper_html_options.update({:class => "inputs #{options[:legend_class] || 'do_sort'}"}))
        elsif wrapper_tag && options[:wrapper] != false
          template.content_tag(wrapper_tag, content, wrapper_html_options)
        else
          content
        end
      end
    end
  end
end

class NilClass
  def val(*args)
    self
  end
end

class Time
  def formatted_datetime
    I18n.l(self, :format => "%d.%m.%Y %H:%M")
  end

  def formatted_date
    I18n.l(self, :format => "%d.%m.%Y")
  end
end

class TrueClass
  def to_i
    1
  end
end

class FalseClass
  def to_i
    0
  end
end

class Object
  def to_bool
    ![false, 'false', '0', 0, 'f', nil].include?(self.respond_to?(:downcase) ? self.downcase : self)
  end
end