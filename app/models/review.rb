class Review < ActiveRecord::Base
  attr_accessible :content, :reviewable_id, :reviewable_type, :title

  belongs_to :reviweable, polymorphic: true
  belongs_to :user

end
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

