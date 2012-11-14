require 'spec_helper'

describe GroupFeature do
  it 'should create new group_feature' do
    group_feature = FactoryGirl.build(:group_feature)
    group_feature.should be_a_kind_of (described_class)
  end

  it 'should have 2 feature items' do
    group_feature = FactoryGirl.create(:group_feature, feature_items: 3)
    puts group_feature.feature_items.map(&:name)
    group_feature.feature_items.size.should eq 3
  end

  it 'should find diff feature_items with place and category' do
    #method self.place_feature_groups
    category_1 = FactoryGirl.create(:category, group_features: 2)
    category_1.group_features.size.should eq 2

    category_2 = FactoryGirl.create(:category, group_features: 1)
    category_2.group_features[0].feature_items.size.should eq 2

    place = FactoryGirl.create(:place)

    place.categories = [category_1]
    place.save!

    feature_items = GroupFeature.place_feature_groups(place.id, category_2.id)
    feature_items_test = (category_2.group_features.map{|g_f| g_f.feature_items.map(&:id)}.flatten - category_1.group_features.map{|g_f| g_f.feature_items.map(&:id)}.flatten)
    feature_items.map(&:id).should eq feature_items_test
  end

  it 'should work with new place create' do
    category_1 = FactoryGirl.create(:category, group_features: 2)
    feature_items = GroupFeature.place_feature_groups(nil, category_1.id)
    feature_items_test = category_1.group_features.map{|g_f| g_f.feature_items.map(&:id)}.flatten
    feature_items.map(&:id).should eq feature_items_test
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

