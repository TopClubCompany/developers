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

  def self.place_feature_groups(place_id, category_id)
    group_features = Category.find(category_id).group_features
    if place_id.present?
      place_group_features = Place.find(place_id).group_features.uniq
      (group_features - place_group_features).map { |group_feature| group_feature.feature_items }.flatten
    else
      group_features.map { |group_feature| group_feature.feature_items }.flatten
    end
  end


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

