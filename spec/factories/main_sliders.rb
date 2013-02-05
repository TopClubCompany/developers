# == Schema Information
#
# Table name: main_sliders
#
#  id         :integer          not null, primary key
#  position   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :main_slider do
  end
end
