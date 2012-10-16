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

end
