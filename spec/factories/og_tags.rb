# == Schema Information
#
# Table name: og_tags
#
#  id         :integer          not null, primary key
#  og_type    :string(255)
#  header_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_og_tags_on_header_id  (header_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :og_tag do
  end
end
