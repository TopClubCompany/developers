# -*- encoding : utf-8 -*-
module Utils
  module Models
    module Structure
      def self.included(base)
        base.send :include, InstanceMethods
        base.send :extend,  ClassMethods
      end
      
      module ClassMethods
        def self.extended(base)
          base.send(:include, Utils::Models::Headerable)
          base.class_eval do
            enumerated_attribute :structure_type, :id_attribute => :kind
            enumerated_attribute :position_type, :id_attribute => :position
            
            validates_presence_of :title
            validates_numericality_of :position, :only_integer => true
            
            has_one :static_page, :dependent => :destroy
            
            acts_as_nested_set
            # awersome nested set depth support
            #set_callback :move, :after, :update_depth
            
            scope :visible, where(:is_visible => true)
            scope :with_kind, proc {|structure_type| where(:kind => structure_type.id) }
            scope :with_depth, proc {|level| where(:depth => level.to_i) }
            scope :with_position, proc {|position_type| where(:position => position_type.id).order('lft DESC') }
          end
        end
        
        def find_by_permalink(value)
          return if value.blank?
          value.to_s.is_int? ? where(:id => value.to_i).first : where(:slug => value.to_s).first
        end
        
        def find_by_permalink!(value)
          record = find_by_permalink(value)
          raise ActiveRecord::RecordNotFound, "Couldn't find structure by #{value}" if record.nil?
          return record
        end
      end
      
      module InstanceMethods
        def moveable?
          return true if new_record?
          !root?
        end
      end
    end
  end
end
