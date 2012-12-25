require 'spec_helper'

describe Reservation do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: reservations
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  phone         :string(255)
#  email         :string(255)
#  special_notes :text
#  time          :time
#  user_id       :integer
#  place_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_reservations_on_place_id  (place_id)
#  index_reservations_on_user_id   (user_id)
#

