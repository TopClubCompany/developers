class Permission < ActiveRecord::Base

  attr_accessor :rule_options

  attr_accessible :actions, :subject, :subject_type, :subject_id, :role_id,
                  :is_visibility, :is_own, :is_work, :assoc, :assoc_ids

  belongs_to :role

  enumerated_attribute :subject_type, :id_attribute => :subject, :class => ::SubjectType

  as_bit_mask :actions, :source => :subject_actions

  scope :per_collection, where(:subject_id => nil)
  scope :per_resource, where(:subject_id.not_eq => nil)

  validates :subject, :inclusion => {:in => SubjectType.all_ids}

  validates_each :assoc, :allow_nil => true, :allow_blank => true do |record, attr, value|
    record.errors.add attr, 'bad assoc' unless record.subject_type.assocs.include?(value.to_sym)
  end

  delegate :model, :to => :subject_type

  after_initialize proc { |r| r.rule_options = {} }

  def for_rule
    rule_options[:is_visible] = false if subject_type.is_work && is_work
    if subject_id
      rule_options[:id] = subject_id
      [[actions, model, rule_options]]
    else
      if assoc.present?
        return [] unless assoc_obj
        if model.column_names.include?("#{assoc}_id")
          rule_options["#{assoc}_id".to_sym] = array_assoc_ids
        else
          rule_options[assoc.to_sym] = {:id => array_assoc_ids}
        end
      end
      rule_options[:is_visible] = true if subject_type.is_visibility && is_visibility
      rule_options[:user_id] = true if subject_type.is_own && is_own
      res = []
      if actions.include?(:create)
        unless actions.size < 2
          res << [actions.without(:create), model, rule_options]
        end
        res << [:create, model]
      else
        res << [actions, model, rule_options]
      end
      res
    end
  end

  def array_assoc_ids
    assoc_ids.to_s.split(',').map(&:to_i)
  end

  def assoc_obj
    @assoc_obj ||= model.reflect_on_association(assoc.to_sym)
  end

  def assoc_klass
    assoc_obj.klass if assoc_obj
  end

  def assoc_pre
    return [] unless assoc_obj
    assoc_klass.where(:id => array_assoc_ids).map(&:for_input_token).to_json
  end

  def subject_actions
    subject_id ? subject_type.member_actions : subject_type.collection_actions
  end

  def for_form
    h = {id: id, subject: subject, actions: actions}
    if subject_id
      h.update(subject_id: subject_id, subject_pre: [subject_resource.try(:for_input_token)].to_json)
    else
      h.update(is_own: is_own, is_work: is_work, is_visibility: is_visibility, is_collection: true,
               assoc: assoc, assoc_ids: array_assoc_ids, :assoc_pre => assoc_pre)
    end
    h
  end

  def subject_resource
    subject_type.model.find_by_id(subject_id)
  end
end
#
# == Schema Information
#
# Table name: permissions
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  actions_mask  :integer
#  context       :integer          default(1)
#  subject       :integer          default(1)
#  subject_id    :integer
#  assoc         :string(255)
#  assoc_ids     :string(255)
#  is_visibility :boolean          default(FALSE)
#  is_own        :boolean          default(FALSE)
#  is_work       :boolean          default(FALSE)
#  role_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_permissions_on_subject_and_subject_id  (subject,subject_id)
#  index_permissions_on_user_id                 (user_id)
#

