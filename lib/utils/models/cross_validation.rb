module Utils
  module Models
    module CrossValidation
      def self.get_fields(obj)
        fields = case obj
                   when "Product"
                   then
                     [:sku, :width, :height, :deep, :volume, :price, :catalogue, :p_group, :company,
                      :style, :field_values, :is_module,
                      :materials, :catalogues, :batches, :assortments, :designers,
                      :p_statuses, :p_groups, :pdf_catalogues, :pdf_catalogue_pages, :tags]
                   when "Article"
                   then
                     []
                   else
                     []
                 end
        ::I18n.available_locales.each do |locale|
          fields << "name_#{locale}".to_sym
          fields << "description_#{locale}".to_sym
        end
        fields
      end

      def self.validation(obj, ids)
        fields = self.get_fields(obj)
        validation_obj_1 = obj.constantize.find(ids.first)
        validation_obj_2 = obj.constantize.find(ids.last)
        value = 0.to_f
        fields_val = 0
        fields.each do |field|
          value_1 = validation_obj_1.send(field)
          value_2 = validation_obj_2.send(field)
          if  value_1.is_a?(Array)
            value_1 = value_1.map(&:id).join()
            value_2 = value_2.map(&:id).join()
            if value_1.size.zero? && value_2.size.zero?
              fields_val+=1
            else
              diff_count = 0
              value_2.each { |val| value_1.include?(val) ? diff_count += 1 : 0 }
              value += self.diff_arr(value_1.size, value_2.size, diff_count).abs
            end
            next
          elsif value_1.is_a?(ActiveRecord::Base)
            value_1 = value_1.nil? ? "" : value_1.id
            value_2 = value_2.nil? ? "" : value_2.id
            if value_1 == "" && value_2 ==""
              fields_val+=1
            else
              value_1 == value_2 ? value += 100 : 0
            end
            next
          end
          if value_1.to_s != ""
            puts field
            puts value_1.to_s
            puts value_2.to_s
            puts value
            value += Utils::Base::Levenshtein.distance_in_procents(value_1.to_s, value_2.to_s).abs
            puts value
            puts "---00"
          else
            fields_val+=1
          end
        end
        value = value.to_f / (fields.size - fields_val)
      end

      def self.diff_arr(size_first, size_last, diff_size)
        if size_last.zero? || size_first.zero?
          0
        else
          diff_size/size_first *100
        end
      end
    end
  end
end