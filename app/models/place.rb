#coding: utf-8
class Place < ActiveRecord::Base

  attr_accessible :phone, :is_visible, :user_id, :url, :location_attributes,
                  :avg_bill, :feature_item_ids, :place_administrators_attributes, :name, :description

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
  has_many :reviews, :as => :reviewable, :dependent => :destroy

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

    if options[:kitchen]
      filters << {query: {terms: {kitchen_ids: options[:kitchen]} }}#{query: "kitchen_ids:#{options[:kitchen].join(' OR ')}"}}}
    end

    if options[:category]
      filters << {query: {terms: {category_ids: options[:category]} }}
    end

    if options[:avg_bill]
      filters << {query: {terms: {category_ids: options[:category]} }}
    end

    if options[:city]
      filters << {query: {flt: {like_text: options[:city], fields: I18n.available_locales.map { |l| "city_#{l}" }} }}
    end

    if filters.empty? && options.empty?
      self.best_places(20).to_json
    else
      tire.search(page: options[:page], per_page: options[:per_page] || 36) do
        if options[:title]
          fields = I18n.available_locales.map { |l| "name_#{l}" }.concat(Location.all_translated_attribute_names)
          query do
            flt options[:title].lucene_escape, :fields => fields, :min_similarity => 0.5
          end
        end
        filter(:and, :filters => filters)
        puts to_curl
      end.to_json
    end

  end

  def self.search_fields
    "id,slug,name_#{I18n.locale},images,lat_lng,marks,overall_mark,category_ids,categories_names,kitchen_ids,kitchens_names,place_feature_item_ids,"
  end

  def self.best_places amount, options={}
    tire.search(page: 1, per_page: amount) do
      sort { by "overall_mark", "desc" }
      if options[:city]
        query do
          flt options[:city].lucene_escape, :fields => I18n.available_locales.map { |l| "city_#{l}" }, :min_similarity => 0.5
        end
      end
      puts to_curl
    end
  end


  def lat_lng
    [location.try(:latitude), location.try(:longitude)].join(',')
  end

  def to_indexed_json
    attrs = [:id, :slug, :avg_bill, :url]
    related_ids = [:kitchen_ids, :category_ids, :place_feature_item_ids, :review_ids
    ]
    methods = %w(lat_lng marks overall_mark)

    Jbuilder.encode do |json|
      json.(self, *self.class.all_translated_attribute_names)
      json.(self.location, *self.location.class.all_translated_attribute_names) if self.location
      json.(self, *attrs)
      json.(self, *methods)

      [:kitchens, :categories, :place_feature_items].each do |a|
        json.set!("#{a}_names", self.send(a).map{|t| t.translations.map(&:name).join(', ') }.join(', '))
      end
      json.(self, *related_ids)

      json.images all_place_images do |json, image|
        json.id image.id
        json.slider_url image.url(:slider)
        json.show_place_image image.url(:place_show)
        json.thumb_url image.url(:thumb)
        json.is_main image.is_main
      end
      json.location_city location.try(:city)
      json.location_city location.try(:street)
      json.house_number location.try(:house_number)
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
    count_reviews = self.reviews.joins(:marks).
        select("reviews.*, marks.mark_type_id as mark_type_id, sum(marks.value) as sum_value, avg(marks.value) as avg_value")
        .group("marks.mark_type_id")
    marks = {}
    count_reviews.each do |review|
      marks.update(MarkType.find(review.mark_type_id).name => {sum: review.sum_value.to_f, avg: review.avg_value.to_f})
    end
    marks.deep_symbolize_keys!
  end

  def overall_mark
    marks.values.map { |mark| mark[:avg] }.avg.round(1)
  end

  def avg_bill_title
    BillType.find(avg_bill).try(:title)
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

