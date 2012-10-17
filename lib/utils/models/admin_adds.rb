# -*- encoding : utf-8 -*-
module Utils
  module Models
    module AdminAdds
      extend ActiveSupport::Concern

      included do
        scope :admin, scoped
        scope :ids, lambda { |ids| where("#{quoted_table_name}.id IN (?)", Utils.val_to_array(ids).push(0)) }

        class_attribute :batch_actions, :instance_writer => false
        self.batch_actions = [:destroy]
      end

      module ClassMethods

        def batch_action(action)
          if batch_actions.include?(action.to_sym)
            action.to_sym
          else
            raise "No such batch action #{action} on model #{self.name}"
          end
        end

      end

    end
  end
end