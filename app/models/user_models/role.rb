class Role < ActiveRecord::Base
  attr_accessible :role_type_id, :is_visible, :name, :description
  attr_accessible :permissions_attributes

  has_many :user_roles, :dependent => :destroy
  has_many :users, :through => :user_roles

  has_many :group_roles, :dependent => :destroy
  has_many :groups, :through => :group_roles
  has_many :grouped_users, :through => :groups, :source => :users

  belongs_to :user
  has_many :permissions, :dependent => :destroy

  enumerated_attribute :role_type, :id_attribute => :role_type_id, :class => ::RoleType
  translates :name, :description

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  accepts_nested_attributes_for :permissions, :allow_destroy => true#, :reject_if => proc {|h| h['actions'].blank? }

  scope :admin, includes(:user)

  ac_field

  def all_users
    users + grouped_users
  end

  def for_form
    permissions.map(&:for_form)
  end

  def update_permissions(attrs, options = {})
    attrs['permissions_attributes'].each do |p_id, attrs_single|
      attrs_single['_destroy'] = 1 if attrs_single['actions'].blank?
      ordered_keys = (["subject", "subject_id"] + attrs_single.keys).uniq
      attrs['permissions_attributes'][p_id] = attrs_single.slice(*ordered_keys)
    end if attrs['permissions_attributes'].present?

    update_attributes(attrs, options)
    all_users.map(&:touch)
  end

  def get_perms
    @perms ||= permissions.map(&:for_rule).push([]).sum
  end

  def self.search_ids(params)
    model = self
    fields = params[:fields] || "_all"
    if params[:size]
      pager_params = {:size => params[:size], :from => params[:from] || 0}
    else
      pager_params = {:page => params[:page], :per_page => params[:per_page] || 12}
    end

    tire.search(pager_params.update({:fields => fields})) do
      query { ids Utils.val_to_array(params[:ids]), model.tire.document_type }

      sort do
        if params[:order]
          by params[:order], params[:sort_mode] || 'desc'
        end
        by :id, :asc
      end

      if respond_to?(:published_cond)
        base_filters = model.published_cond.dup
        filter(:and, :filters => base_filters)
      end

      Rails.logger.debug { Utils.pretty(to_json) }
    end
  end

end
#
# == Schema Information
#
# Table name: roles
#
#  id           :integer          not null, primary key
#  role_type_id :integer          default(1)
#  user_id      :integer
#  is_visible   :boolean          default(TRUE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_roles_on_user_id  (user_id)
#

