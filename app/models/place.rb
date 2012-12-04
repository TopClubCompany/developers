
#coding: utf-8

class Place < ActiveRecord::Base

  attr_accessible :phone, :is_visible, :user_id, :url, :location_attributes,
                  :avg_bill, :feature_item_ids, :place_administrators_attributes

  belongs_to :user

  has_many :place_categories, :dependent => :destroy
  has_many :categories, :through => :place_categories

  has_many :place_kitchens, :dependent => :destroy
  has_many :kitchens, :through => :place_kitchens

  has_many :place_feature_items
  has_many :feature_items, :through => :place_feature_items

  has_many :group_features, :through => :feature_items
  has_many :place_administrators, :dependent => :destroy

  has_many :notes
  has_many :events
  has_many :reviews, :as => :reviewable

  enumerated_attribute :bill, :id_attribute => :avg_bill, :class => ::BillType

  #belongs_to :category
  #belongs_to :kitchen

  has_one :place_image, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => true}
  has_many :place_images, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => false}
  has_many :all_place_images, :class_name => 'PlaceImage', :as => :assetable, :dependent => :destroy, :order => 'is_main DESC'


  has_one :location, :as => :locationable, :dependent => :destroy, :autosave => true

  accepts_nested_attributes_for :location, :reviews, :place_administrators, :allow_destroy => true, :reject_if => :all_blank

  translates :name, :description

  fileuploads :place_image, :place_images

  include Tire::Model::Search
  include Tire::Model::Callbacks

  include Utils::Models::Base
  include Utils::Models::Translations
  include Utils::Models::AdminAdds


  as_token_ids :category, :kitchen

  #PER_PAGE = 25


  settings Utils::Elastic::ANALYZERS do
    mapping do
      indexes :id, type: 'integer'
      ::I18n.available_locales.each do |loc|
        indexes "name_#{loc}", :type => "multi_field",
                :fields => {
                    "name_#{loc}" => {:type => 'string', :analyzer => "analyzer_#{loc}", :boost => 100},
                    "exact" => {:type => 'string', :index => "not_analyzed"}
                }
        indexes "description_#{loc}", boost: 5, analyzer: "analyzer_#{loc}"
      end
      indexes :lat_lng, type: 'geo_point'
    end
  end

  def self.paginate(options = {})
    includes(:kitchens, :categories, :place_feature_items, :location).paginate(:page => options[:page], :per_page => options[:per_page]).to_a
  end


  def self.search(options = {})
    filters = []
    categories = Category.order :created_at
    kitchens   = Kitchen.order  :created_at
    #@distances  = Filter.all_for 'distance'
    avg_bills   = Filter.all_for 'avg_bill'
    page_num = (options[:page] || 1).to_i
    query = { match_all: {} }

    if options[:kitchen]
      filters << {query: {query_string: {query: "kitchen_ids:#{options[:kitchen].join(' OR ')}"}}}
    end

    if options[:category]
      filters << {query: {query_string: {query: "category_ids:#{options[:category].join(' OR ')}"}}}
    end

    if options[:avg_bill]
      filters << {query: {query_string: {query: "avg_bill:#{options[:avg_bill].join(' OR ')}"}}}
    end
    if filters.empty?
      {}
    else
      query = Tire.search 'places', query: { filtered: {
          query: query,
          filter: { and: filters }
      } },
                          from: (page_num - 1) * 25,
                          size: 25
      total_places = query.results.total
      query.results.map{ |r| r.load }
      query.results.to_json
    end

  end


  def lat_lng
    [location.try(:latitude), location.try(:longitude)].join(',')
  end

  def to_indexed_json
    attrs = [:id, :slug, :avg_bill, :url]
    related_ids = [:kitchen_ids, :category_ids, :place_feature_item_ids
    ]
    methods = ['lat_lng']

    Jbuilder.encode do |json|
      json.(self, *self.class.all_translated_attribute_names)
      json.(self, *attrs)
      json.(self, *methods)

      [:kitchens, :categories, :place_feature_items].each do |a|
        json.set!("#{a}_names", self.send(a).map{|t| t.translations.map(&:name).join(' ') }.join(' '))
      end

      json.(self, *related_ids)

      json.images all_place_images do |json, image|
        json.id image.id
        json.url image.url(:thumb)
        json.is_main image.is_main
      end
    end
  end


  def near
    query = Tire.search 'places', query: { filtered: {
        query:  { match_all: {} },
        filter: { geo_distance: { distance: "10km", lat_lng: self.lat_lng } }
    } }
    near = query.results.map(&:load)
    near.reject!{ |p| p.id == self.id }
  end

  def marks
    marks = { food: 0, service: 0, ambiance: 0, pricing: 0, overall: 0, count: 0 }
     reviews.each do |review|
       marks[:count] += 1
       marks.except(:count, :overall).each do |k, _|
         marks[k] += review.mark[k].to_f
         marks[:overall] += review.mark[k].to_f
       end
     end
    marks.except(:count, :overall).each { |k, _|  marks[k] /= marks[:count] } unless marks[:count].zero?
    marks[:overall] /= marks[:count]*4
    marks
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
#  phone      :string(255)
#  url        :string(255)
#  avg_bill   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_places_on_slug     (slug) UNIQUE
#  index_places_on_user_id  (user_id)
#

