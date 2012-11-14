class GroupFeatureCategory < ActiveRecord::Base
  attr_accessible :group_feature_id, :category_id

  belongs_to :group_feature
  belongs_to :category
end
# == Schema Information
#
# Table name: group_feature_categories
#
#  id               :integer          not null, primary key
#  group_feature_id :integer
#  category_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_group_feature_categories_on_category_id       (category_id)
#  index_group_feature_categories_on_group_feature_id  (group_feature_id)
#

