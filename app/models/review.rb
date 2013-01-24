class Review < ActiveRecord::Base
  attr_accessible :content, :reviewable_id, :reviewable_type, :title, :user_id

  belongs_to :user
  belongs_to :place
  belongs_to :reviweable, polymorphic: true

  has_many :marks

  self.per_page = 6

  def avg_mark
    marks.average(:value).to_f
  end

  def for_mustache
    {
        overall: avg_mark,
        marks: marks.map{|mark| {mark_type: mark.mark_type.title, value: mark.value}}
    }
  end

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
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_reviews_on_reviewable_id_and_reviewable_type  (reviewable_id,reviewable_type)
#  index_reviews_on_user_id                            (user_id)
#

