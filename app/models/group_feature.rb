class GroupFeature < ActiveRecord::Base
  attr_accessible :name, :description, :is_visible, :feature_items_attributes

  has_many :group_feature_categories, :dependent => :destroy
  has_many :categories, :through => :group_feature_categories
  has_many :feature_items


  accepts_nested_attributes_for :feature_items, :allow_destroy => true, :reject_if => :all_blank

  translates :name, :description
  
  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  as_token_ids :category

end
# == Schema Information
#
# Table name: group_features
#
#  id         :integer          not null, primary key
#  is_visible :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

