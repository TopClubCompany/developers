require 'spec_helper'

describe Category do

end
# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  slug               :string(255)      not null
#  user_id            :integer
#  is_visible         :boolean          default(TRUE), not null
#  parent_id          :integer
#  lft                :integer          default(0)
#  rgt                :integer          default(0)
#  depth              :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  is_visible_on_main :boolean          default(FALSE)
#  position           :integer
#  css_id             :string(255)
#
# Indexes
#
#  index_categories_on_lft_and_rgt  (lft,rgt)
#  index_categories_on_parent_id    (parent_id)
#  index_categories_on_slug         (slug) UNIQUE
#  index_categories_on_user_id      (user_id)
#

