
#coding: utf-8

class Place < ActiveRecord::Base

  attr_accessible :lat, :lon, :phone, :zoom, :is_visible, :user_id, :url

  belongs_to :user

  has_many :place_categories, :dependent => :destroy
  has_many :categories, :through => :place_categories

  has_many :place_kitchens, :dependent => :destroy
  has_many :kitchens, :through => :place_kitchens

  has_many :notes
  has_many :events
  has_many :reviews
  has_many :price_ranges

  accepts_nested_attributes_for :reviews, :price_ranges

  #belongs_to :category
  #belongs_to :kitchen

  has_one :place_image, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => true}
  has_many :place_images, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => false}

  translates :name, :description, :address

  fileuploads :place_image, :place_images

  include Tire::Model::Search
  include Tire::Model::Callbacks

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  PER_PAGE = 10

  mapping do
    indexes :lat_lng, type: 'geo_point'
  end

  def lat_lng
    [lat, lng].join(',')
  end

  def to_indexed_json
    to_json except: ['lat', 'lng'], methods: ['lat_lng']
  end

  def near
    query = Tire.search 'places', query: { filtered: {
        query:  { match_all: {} },
        filter: { geo_distance: { distance: "10km", lat_lng: self.lat_lng } }
    } }
    near = query.results.map(&:load)
    near.reject!{ |p| p.id == self.id }
  end

  def self.recomended_for user
    Place             # TODO need some places to recommend to this User
  end

  def rating
    result = $redis.lrange(self.redis_key(:rating),
                           0, $redis.llen(self.redis_key(:rating)).to_i)
    result = result.map(&:to_i)
    result.avg
  end

  def rated_users
    $redis.lrange(self.redis_key(:rated_users),
                  0, $redis.llen(self.redis_key(:rated_users)).to_i)
  end

  def rate! val, user_id
    unless rated_users.include? user_id.to_s
      $redis.lpush(self.redis_key(:rated_users), user_id)
      $redis.lpush(self.redis_key(:rating), val) if (1..5).include? val
    end
    rating
  end

  # TODO make dynamic methods here
  def redis_key str
    "place:#{self.id}:#{str}"
  end

  def favorite_for user_id
    $redis.lpush(self.redis_key(:in_favorites), user_id) unless in_favorites.include?(user_id.to_s)
    in_favorites.count
  end

  def in_favorites
    $redis.lrange(self.redis_key(:in_favorites),
                       0, $redis.llen(self.redis_key(:in_favorites)).to_i)
  end

  def planned_by user_id
    $redis.lpush(self.redis_key(:in_planes), user_id) unless in_planes.include?(user_id.to_s)
    in_planes.count
  end

  def in_planes
    $redis.lrange(self.redis_key(:in_planes),
                       0, $redis.llen(self.redis_key(:in_planes)).to_i)
  end

  def visited_by user_id
    $redis.lpush(self.redis_key(:in_visited), user_id) unless in_visited.include?(user_id.to_s)
    in_visited.count
  end

  def in_visited
    $redis.lrange(self.redis_key(:in_visited),
                       0, $redis.llen(self.redis_key(:in_visited)).to_i)
  end

end
# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  user_id    :integer
#  is_visible :boolean          default(TRUE), not null
#  lat        :float
#  lng        :float
#  zoom       :float
#  phone      :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kitchen_id :integer
#  avgbill    :integer
#  picture    :string(255)
#
# Indexes
#
#  index_places_on_slug     (slug) UNIQUE
#  index_places_on_user_id  (user_id)
#

