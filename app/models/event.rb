# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  start_at   :datetime
#  picture    :string(255)
#  kind       :string(255)
#  title      :string(255)
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Event < ActiveRecord::Base
  belongs_to :place

  def attenders
    $redis.lrange(self.attenders_redis_key,
                  0, $redis.llen(self.attenders_redis_key).to_i)
  end

  def attenders= user_id
    $redis.lpush(self.attenders_redis_key, user_id)
  end

  def attenders_redis_key
    "event:#{self.id}:attenders"
  end

  #alias_attribute :name, :title

  #include Utils::Models::Base
  include Utils::Models::AdminAdds



end
