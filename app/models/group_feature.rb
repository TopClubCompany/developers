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
    group_features = Category.includes(:group_features => [:feature_items => :translations]).find(category_id).group_features
    if place_id.present?
      place_group_features = Place.includes(:group_features).find(place_id).group_features
      group_features = (group_features - place_group_features)
    end
      group_features.map { |group_feature| group_feature.feature_items }.flatten
      .group_by{|f_i| [f_i.group_feature.name, f_i.group_feature.id]}
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

