#coding: utf-8
class Place < ActiveRecord::Base

  attr_accessible :phone, :is_visible, :user_id, :url, :location_attributes, :week_days_attributes,
                  :avg_bill, :feature_item_ids, :place_administrators_attributes, :name, :description,
                  :week_days_ids

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
  has_many :week_days


  enumerated_attribute :bill, :id_attribute => :avg_bill, :class => ::BillType


  has_one :place_image, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => true}
  has_many :place_images, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => false}
  has_many :all_place_images, :class_name => 'PlaceImage', :as => :assetable, :dependent => :destroy, :order => 'is_main DESC'


  has_one :location, :as => :locationable, :dependent => :destroy, :autosave => true

  accepts_nested_attributes_for :location, :reviews, :place_administrators, :week_days,
                                :allow_destroy => true, :reject_if => :all_blank

  translates :name, :description

  fileuploads :place_image, :place_images

  elasticsearch

  include Utils::Models::Base
  include Utils::Models::Elastic
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  as_token_ids :category, :kitchen


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

    if options[:kitchen].present?
      filters << {query: {terms: {kitchen_ids: options[:kitchen].split(',')} }}#{query: "kitchen_ids:#{options[:kitchen].join(' OR ')}"}}}
    end

    if options[:category].present?
      filters << {query: {terms: {category_ids: options[:category].split(',')} }}
    end

    if options[:price].present?
      filters << {query: {terms: {avg_bill: options[:price].split(',')} }}
    end

    if filters.empty? && options.empty?
      self.best_places(4, options)
    else

      if options[:city].present?
        filters << {query: {flt: {like_text: options[:city], fields: I18n.available_locales.map { |l| "city_#{l}" }} }}
      end

      tire.search(page: options[:page], per_page: options[:per_page] || 4) do
        if options[:title].present?
          fields = I18n.available_locales.map { |l| "name_#{l}" }.concat(Location.all_translated_attribute_names)
          query do
            flt options[:title].lucene_escape, :fields => fields, :min_similarity => 0.5
          end
          sort { by "overall_mark", "desc" }
        end
        filter(:and, :filters => filters)
      end
    end

  end

  def self.search_fields
    "id,slug,name_#{I18n.locale},images,lat_lng,marks,overall_mark,category_ids,categories_names,kitchen_ids,kitchens_names,place_feature_item_ids,"
  end

  def self.best_places amount, options={}
    tire.search(page: options[:page] || 1, per_page: amount) do
      sort { by "overall_mark", "desc" }
      if options[:city]
        query do
          flt options[:city].lucene_escape, :fields => I18n.available_locales.map { |l| "city_#{l}" }, :min_similarity => 0.5
        end
      end
    end
  end


  def lat_lng
    [location.try(:latitude), location.try(:longitude)].join(',')
  end

  def to_indexed_json
    attrs = [:id, :slug, :avg_bill, :url]
    related_ids = [:kitchen_ids, :category_ids, :place_feature_item_ids, :review_ids
    ]
    methods = %w(lat_lng marks overall_mark avg_bill_title)

    Jbuilder.encode do |json|
      json.(self, *self.class.all_translated_attribute_names)
      json.(self.location, *self.location.class.all_translated_attribute_names) if self.location
      json.(self, *attrs)
      json.(self, *methods)

      [:kitchens, :categories, :place_feature_items].each do |a|
        I18n.available_locales.each do |locale|
          json.set!("#{a}_names_#{locale}", self.send(a).map{|t| t.send("name_#{locale}")}.join(', '))
        end
      end
      json.(self, *related_ids)

      json.images all_place_images do |json, image|
        json.id image.id
        json.slider_url image.url(:slider)
        json.show_place_image image.url(:place_show)
        json.thumb_url image.url(:thumb)
        json.is_main image.is_main
      end

      json.place_image do |json|
        json.id place_image.id
        json.slider_url place_image.url(:slider)
        json.show_place_image place_image.url(:place_show)
        json.thumb_url place_image.url(:thumb)

      end if place_image
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
    BillType.find(avg_bill).title if avg_bill
  end

  def self.for_mustache(place)
    res = {}
    res[:id] = place.id
    res[:slug] = place.slug || place.id
    res[:name] = place["name_#{I18n.locale}"]
    res[:image_path] = place.place_image.try(:slider_url)
    res[:review_count] = place.review_ids.try(:count)
    res[:description] = place["description_#{I18n.locale}"]
    res[:kitchens] = place["kitchens_names_#{I18n.locale}"]
    res[:categories] = place["categories_names_#{I18n.locale}"]
    res[:place_feature_items] = place["place_feature_items_names_#{I18n.locale}"]
    res[:city] = place["city_#{I18n.locale}"]
    res[:street] = place["street_#{I18n.locale}"]
    res[:county] = place["county_#{I18n.locale}"]
    res[:house_number] = place["house_number"]
    res[:avg_bill_title] = place["avg_bill_title"]
    res[:overall_mark] = place["overall_mark"]
    res[:marks] = place["marks"]
    res[:lat_lng] = place["lat_lng"]
    res
  end

  def self.for_autocomplite(place)
    res = {}
    res[:id] = place.id
    res[:slug] = place.slug || place.id
    res[:name] = place["name_#{I18n.locale}"]
    res[:street] = place["street_#{I18n.locale}"]
    res[:county] = place["county_#{I18n.locale}"]
    res
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

