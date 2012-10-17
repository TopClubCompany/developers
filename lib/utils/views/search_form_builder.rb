module Utils
  module Views
    class SearchFormBuilder < ::Ransack::Helpers::FormBuilder
      delegate :content_tag, :tag, :params,
               :text_field_tag, :check_box_tag, :radio_button_tag, :label_tag, :select_tag,
               :options_for_select, :options_from_collection_for_select, :to => :@template

      def input(attr, options={})
        content_tag :div, :class => 'clearfix' do
          send("#{filed_type(attr, options)}_field", attr, options)
        end
      end

      def select_field(attr, options={})
        label(attr, options[:label] || object.klass.han(attr)) + content_tag(:div, :class => 'controls') do
          param = "#{attr}#{'_id' if options[:assoc]}_eq"
          if options[:collection].first.respond_to?(:id)
            opts = options_from_collection_for_select(options[:collection], :id, :title, params[:q][param])
          else
            opts = options_for_select(options[:collection], params[:q][param])
          end
          select_tag("q[#{param}]", opts, options.merge(:include_blank => true, :class => 'do_chosen'))
        end
      end

      def date_field(attr, options={})
        label(attr, options[:label]) + content_tag(:div, :class => 'controls') do
          gt_param, lt_param = "#{attr}_gteq", "#{attr}_lteq"
          text_field_tag("q[#{gt_param}]", params[:q][gt_param], :class => 'input-small datepicker') + ' - ' +
          text_field_tag("q[#{lt_param}]", params[:q][lt_param], :class => 'input-small datepicker')
        end
      end

      def string_field(attr, options={})
        label(attr, options[:label]) + content_tag(:div, :class => 'controls') do
          param = "#{attr}_cont"
          text_field_tag("q[#{param}]", params[:q][param])
        end
      end

      def number_field(attr, options={})
        label(attr, options[:label]) + content_tag(:div, :class => 'controls') do
          opts = [['=', 'eq'], ['>', 'gt'], ['<', 'lt']].map { |m| [m[0], "#{attr}_#{m[1]}"] }
          current_filter = (opts.detect { |m| params[:q][m[1]].present? } || opts.first)[1]
          select_tag('', options_for_select(opts, current_filter), :class => 'input-small predicate-select') +
          text_field_tag("q[#{current_filter}]", params[:q][current_filter], :class => 'input-small')
        end
      end

      def boolean_field(attr, options={})
        content_tag(:div, :class => 'pull-left') do
          param = "#{attr}_eq"
          content_tag(:label, :class => 'checkbox inline') do
            check_box_tag("q[#{param}]", 1, params[:q][param].to_i == 1, :class => 'inline') + I18n.t('simple_form.yes')
          end +
          content_tag(:label, :class => 'checkbox inline') do
            check_box_tag("q[#{param}]", 0, params[:q][param] && params[:q][param].to_i == 0, :class => 'inline') + I18n.t('simple_form.no')
          end
        end + label(attr, options[:label], :class => 'right-label')
      end

      def filed_type(attr, options={})
        return options[:as].to_sym if options[:as]
        return :string if attr =~ /^translations_/

        input_type = @object.klass.columns_hash[attr.to_s].try(:type)

        if input_type
          return :select if options[:collection]
        else
          assoc = @object.klass.reflect_on_association(attr.to_sym)
          if assoc
            options[:collection] ||= assoc.klass.limit(500)
            options[:assoc] = true
            return :select
          end
        end

        case input_type
          when :timestamp, :datetime, :date
            :date
          when :decimal, :float, :integer
            :number
          else
            input_type or raise "No available input type for #{attr}"
        end
      end

    end
  end
end