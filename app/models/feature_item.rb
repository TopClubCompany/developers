class FeatureItem < ActiveRecord::Base
  attr_accessible :name, :is_visible, :group_feature_id

  belongs_to :group_feature

  translates :name

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds


end
# == Schema Information
#
# Table name: feature_items
#
#  id               :integer          not null, primary key
#  is_visible       :boolean          default(TRUE)
#  group_feature_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_feature_items_on_group_feature_id  (group_feature_id)
#

