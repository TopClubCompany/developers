# -*- encoding : utf-8 -*-
module Utils
  module Models
    module NestedSet
      extend ActiveSupport::Concern

      module ClassMethods
        def self.extended(base)
          base.class_eval do
            acts_as_nested_set
            # awersome nested set depth support
            #set_callback :move, :after, :update_depth

            scope :with_kind, proc {|structure_type| where(:kind => structure_type.id) }
            scope :with_depth, proc {|level| where(:depth => level.to_i) }
            scope :with_position, proc {|position_type| where(:position => position_type.id) }
          end
        end
      end

      def deep_parent
        root? ? self : self.parent.try(:deep_parent)
      end

    end
  end
end
