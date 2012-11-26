# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewable_id   :integer
#  reviewable_type :string(255)
#  title           :string(255)
#  content         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    reviewable_id 1
    reviewable_type "MyString"
    content "MyText"
  end
end
