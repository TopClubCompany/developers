require 'spec_helper'

describe FeatureItem do
  pending "add some examples to (or delete) #{__FILE__}"
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

