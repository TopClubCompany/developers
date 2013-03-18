#coding: utf-8
class Place < ActiveRecord::Base

  attr_accessible :phone, :is_visible, :user_id, :url, :location_attributes, :week_days_attributes,
                  :avg_bill, :feature_item_ids, :place_administrators_attributes, :place_menus_attributes,
                  :name, :description, :week_days_ids

  belongs_to :user

  has_many :place_categories, :dependent => :destroy
  has_many :categories, :through => :place_categories

  has_many :place_kitchens, :dependent => :destroy
  has_many :kitchens, :through => :place_kitchens

  has_many :place_feature_items, :dependent => :destroy
  has_many :feature_items, :through => :place_feature_items

  has_many :group_features, :through => :feature_items
  has_many :place_administrators, :dependent => :destroy

  has_many :notes
  has_many :events
  has_many :reviews, :as => :reviewable, :dependent => :destroy
  has_many :week_days, :dependent => :destroy
  has_many :day_discounts, :through => :week_days
  has_many :reservations, :dependent => :destroy
  has_many :place_menus, :dependent => :destroy

  enumerated_attribute :bill, :id_attribute => :avg_bill, :class => ::BillType


  has_one :place_image, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => true}
  has_many :place_images, :as => :assetable, :dependent => :destroy, :conditions => {:is_main => false}
  has_many :all_place_images, :class_name => 'PlaceImage', :as => :assetable, :dependent => :destroy, :order => 'is_main DESC'
  has_one :slider, :as => :assetable, :dependent => :destroy


  has_one :location, :as => :locationable, :dependent => :destroy, :autosave => true

  accepts_nested_attributes_for :location, :reviews, :place_administrators, :week_days, :place_menus,
                                :allow_destroy => true, :reject_if => :all_blank


  translates :name, :description

  fileuploads :place_image, :place_images, :slider

  elasticsearch

  include Utils::Models::Base
  include Utils::Models::Elastic
  include Utils::Models::Translations
  include Utils::Models::AdminAdds

  as_token_ids :category, :kitchen

  class_attribute :visible_filter, :instance_writer => false

  self.visible_filter = [
    {:term => {:is_visible => true}}
  ]

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

        indexes "street_#{loc}", :type => "multi_field",
                :fields => {
                    "street_#{loc}" => {:type => 'string', :analyzer => "analyzer_#{loc}", :boost => 100},
                    "exact" => {:type => 'string', :index => "not_analyzed"}
                }
      end
      indexes :overall_mark, type: 'double'
      indexes :created_at, type: 'date', format: 'dateOptionalTime'
      indexes :lat_lng, type: 'geo_point'
      indexes :is_has_slider_image, type: 'boolean'

      #DayType.all.each do |day|
      #  %w(start_at end_at).each do |work_time|
      #    indexes "week_day_#{day.id}_#{work_time}", type: :double
      #  end
      #end

    end
  end

  def self.paginate(options = {})
    includes(:kitchens, :categories, :place_feature_items, :location).paginate(:page => options[:page], :per_page => options[:per_page]).to_a
  end

  def self.for_slider options={}
    tire.search(page: options[:page], per_page: options[:per_page] || 4) do
      query do
        custom_score({script: "random()*20"}) do
          all {}
        end
      end
      filter :exists, :field => :is_has_slider_image
      sort { by("_score", "desc") }
      puts to_curl
    end
  end

  #slider


  def self.search(options = {})
    filters = []
    categories = []
    sort = self.case_order(options[:sort_by] || 'overall_mark')

    if options[:kitchen].present?
      filters << {query: {terms: {kitchen_ids: options[:kitchen].split(',')} }}
    end


    categories << options[:category].split(',') if options[:category].present?
    if options[:id].present?
      categories << Category.find(options[:id].split(',')).map(&:id)
    end

    unless categories.empty?
      filters << {query: {terms: {category_ids: categories.flatten} }}
    end

    if options[:price].present?
      filters << {query: {terms: {avg_bill: options[:price].split(',')} }}
    end

    if options[:place_id].present?
      filters << {query: {term: {id: options[:place_id]} }}
    end

    filters += self.time_filter(options) if options[:opened].present?

    if options[:distance].present? && options[:current_point].present?
      distance = options[:distance].split(',').map(&:to_i).max
      distance = PlaceGeoType.find(distance).distance
      filters << { geo_distance_range: {lat_lng: options[:current_point] }.merge(distance) }
    end

    if filters.empty? && options.empty?
      self.best_places(10, options)
    else

      if options[:city].present?
        filters << {query: {flt: {like_text: options[:city], fields: I18n.available_locales.map { |l| "city_#{l}" }} }}
      end

      tire.search(page: options[:page], per_page: options[:per_page] || 10) do
        if options[:title_or_location].present?
          fields = I18n.available_locales.map { |l| "name_#{l}" }.concat(Location.all_translated_attribute_names)
          query do
            flt options[:title_or_location].lucene_escape, :fields => fields, :min_similarity => 0.9
          end
          sort { by sort, "desc" }
        end
        filter(:and, :filters => filters)
        puts to_curl
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

  def self.new_places amount, options={}
    tire.search(page: options[:page] || 1, per_page: amount) do
      sort do
         by("created_at", "desc")
         by("overall_mark", "asc")
      end
      if options[:city]
        query do
          flt options[:city].lucene_escape, :fields => I18n.available_locales.map { |l| "city_#{l}" }, :min_similarity => 0.5
        end
      end
    end
  end

  def self.tonight_available amount, options={}
    current_day = PlaceUtils::PlaceTime.wday(DateTime.now.wday) + 1
    field = "week_day_#{current_day}"
    filters = []
    filters << {query: {terms: {:"#{field}" => [19, 3], minimum_match: 2} }}
    tire.search(page: options[:page] || 1, per_page: amount) do
      sort { by("overall_mark", "desc") }
      if options[:city]
        query do
          flt options[:city].lucene_escape, :fields => I18n.available_locales.map { |l| "city_#{l}" }, :min_similarity => 0.5
        end
      end
      filter(:and, :filters => filters)
    end
  end


  def lat_lng
    [location.try(:latitude), location.try(:longitude)].compact.join(',') if location
  end

  def to_indexed_json
    attrs = [:id, :slug, :avg_bill, :url, :created_at, :is_visible]
    related_ids = [:kitchen_ids, :category_ids, :place_feature_item_ids, :review_ids, :week_day_ids,
                   :day_discount_ids
    ]
    methods = %w(lat_lng marks overall_mark)

    Jbuilder.encode do |json|
      json.(self, *self.class.all_translated_attribute_names)
      json.(self.location, *self.location.class.all_translated_attribute_names) if self.location
      json.(self, *attrs)
      json.(self, *methods)

      json.house_number location.house_number if location.respond_to?(:house_number)

      [:kitchens, :categories, :place_feature_items].each do |a|
        I18n.available_locales.each do |locale|
          json.set!("#{a}_names_#{locale}", self.send(a).map{|t| t.send("name_#{locale}")}.join(', '))
        end
      end

      I18n.available_locales.each do |locale|
        json.set!("avg_bill_title_#{locale.to_s}", self.avg_bill_title(locale))
      end

      json.set!("discounts", self.discounts_index)

      self.week_days.each do |week_day|
        json.set!("week_day_#{week_day.day_type_id}", week_day.range_time)
      end if self.week_days.any?

      json.(self, *related_ids)

      json.images all_place_images do |json, image|
        json.id image.id
        json.slider_url image.url(:slider)
        json.show_place_image image.url(:place_show)
        json.thumb_url image.url(:thumb)
        json.main_url image.url(:main)
        json.is_main image.is_main
      end

      if slider
        json.slider do |json|
          json.id slider.id
          json.url slider.url(:main)
        end
        json.set!("is_has_slider_image", true)
      end

      json.place_image do |json|
        json.id place_image.id
        json.slider_url place_image.url(:slider)
        json.show_place_image place_image.url(:place_show)
        json.main_url place_image.url(:main)
        json.thumb_url place_image.url(:thumb)

      end if place_image

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
      marks.update(MarkType.find(review.mark_type_id).name => {sum: review.sum_value.to_f, avg: review.avg_value.to_f,
                                                               id: review.mark_type_id})
    end
    marks.deep_symbolize_keys!
  end

  def overall_mark
    marks.values.select { |mark| MarkType.find(mark[:id]).included_in_overall }.map { |mark| mark[:avg] }.avg.round(1)
  end

  def avg_bill_title(locale=I18n.locale.to_sym)
    bill.title(locale) if bill
  end

  def all_images
    @images ||= place_images.unshift(place_image)
  end

  def self.time_filter(options={})
    fields = []
    if options[:reserve_time].present?
      time = self.en_to_time(options[:reserve_time])
      current_day = options[:reserve_date].present? ? DateTime.parse(options[:reserve_date]).wday : DateTime.now.wday
      current_day = PlaceUtils::PlaceTime.wday(current_day)
      field = "week_day_#{current_day}"
      fields << {query: {terms: {:"#{field}" => [time.split(":").first.to_i], minimum_match: 1} }}
    end
    fields
  end

  def self.for_mustache(place, options={})
    time_now = Time.now + 90.minute
    current_day = options[:reserve_date].present? ? DateTime.parse(options[:reserve_date]).wday : DateTime.now.wday
    current_day = PlaceUtils::PlaceTime.wday(current_day)
    truncated_time_now = Time.at(time_now.to_i - time_now.sec - time_now.min % 15 * 60)
    time = options[:reserve_time].present? ? Time.parse(options[:reserve_time]) : truncated_time_now
    #options[:reserve_time] = truncated_time_now.strftime("%H:%M") unless options[:reserve_time].present?
    options[:image_url] ||= :slider_url
    res = {}
    res[:id] = place.id
    res[:slug] = place.slug
    res[:name] = place["name_#{I18n.locale}"].slice(0, 22)
    res[:title] = place["name_#{I18n.locale}"]
    res[:image_path] = place.place_image.try(options[:image_url])
    res[:review_count] = place.review_ids.try(:count)
    res[:description] = place["description_#{I18n.locale}"]
    res[:kitchens] = place["kitchens_names_#{I18n.locale}"]
    res[:categories] = place["categories_names_#{I18n.locale}"]
    res[:place_feature_items] = place["place_feature_items_names_#{I18n.locale}"]
    res[:city] = place["city_#{I18n.locale}"]
    res[:street] = place["street_#{I18n.locale}"]
    res[:county] = place["county_#{I18n.locale}"]
    res[:house_number] = place["house_number"]
    res[:avg_bill_title] = place["avg_bill_title_#{I18n.locale}"]
    res[:overall_mark] = place["overall_mark"]
    res[:star_rating] = "left: #{place["overall_mark"] * 20}%"
    res[:marks] = place["marks"]
    res[:lat_lng] = place["lat_lng"]
    offers = self.today_discount(place["discounts"], options)
    unless offers[1].is_a? NilClass
      res[:special_offer] = offers[1].size > 0
      res[:special_offers] = offers[1].map do |obj|
        {
           :popover_data => {
            trigger: 'click',
            title: obj["title_#{I18n.locale}"],
            content: "From #{'%.2f' % obj["from_time"].to_f} to #{'%.2f' % obj["to_time"].to_f}",
            placement: "top"
          }
        }
      end
    end
    res[:discount] = offers[0].try{|offer| offer.discount.try(:to_i) }
    res[:place_url] = "/#{I18n.locale}/#{place.slug}-#{place['city_en'].try{|city| city.downcase.gsub(' ','_')}}"
    res[:star_rating] = self.get_star_rating(place)
    res[:is_favourite] = UserFavoritePlace.liked?(options[:current_user].try(:id), place.id)
    res[:timing] = self.order_time(place, time, current_day)
    res[:like_place] = I18n.t('like_place')
    res[:special_offers_text] = I18n.t('search.special_offers')
    #raise self.order_time(place, time, current_day).inspect
    res
  end


  def self.order_time place, time, wday
    [30, 15, 0, -15, -30].each_with_index.map do |i, index|
      array_time = place["week_day_#{wday}"]
      ::PlaceUtils::PlaceTime.find_available_time(i, time, array_time)
    end
  end

  def discounts_index
    self.send(:day_discounts).with_translation.includes(:week_day).map do |day_discount|
      {
          id: day_discount.id,
          is_discount: day_discount.is_discount,
          day: day_discount.week_day.day_type_id,
          discount:  day_discount.discount,
          to_time: day_discount.to_time,
          from_time: day_discount.from_time
      }.update(I18n.available_locales.inject({}) do |h, locale|
        h.update({:"title_#{locale}" => day_discount.send("title_#{locale}")})
      end)
    end
  end

  def humanable_schedule
    groups = week_days.group_by do |day|
      [:start_at, :end_at].map do |point|
        if day.send(point).to_s.present?
          if I18n.locale.to_sym == :en
            Time.parse(("%5.2f" % day.send(point).to_s).sub(".",":")).strftime("%I:%M%p")
          else
            Time.parse(("%5.2f" % day.send(point).to_s).sub(".",":")).strftime("%H:%M")
          end
        end
      end.join('-')
    end

    day_abbr = DayType.all.map {|day| day.title(:short)}
    groups.map do |time, days|
      present_abbr = days.map { |day| day.day_type_title(:short) }
      (day_abbr.length).downto(2) do |length|
        day_abbr.each_cons(length) do |day_abbr_con|
          present_abbr.each_cons(day_abbr_con.length).with_index do |pres_abbr_con, index|
            if day_abbr_con == pres_abbr_con
              present_abbr[index, index + pres_abbr_con.length] = pres_abbr_con[0] + '-' + pres_abbr_con[-1]
            end
          end
        end
      end

      "<b>#{present_abbr.join(', ')}:</b> #{time}"
    end
  end


  def self.count_visible options={}
    model = self
    tire.search(search_type: "scan", scroll: "10m") do
      if options[:city]
        query do
          flt options[:city].lucene_escape, :fields => I18n.available_locales.map { |l| "city_#{l}" }, :min_similarity => 0.5
        end
      end
      filter(:and, :filters => model.visible_filter)
    end.total
  end


  def self.deparam(url)
    replace_url = url
    City.all.map{|obj| obj.slug}.map{|i| [i].zip("#{i}_oblast")}.flatten.each do |slug|
      replace_url = url.to_s.sub(/-#{slug}$/,'')
      if replace_url != url
        break
      end
    end
    replace_url
  end

  def address
    if location
      [location.street, location.house_number].join(". ")
    end
  end

  def max_discount
    day_discounts.special.try { |special| special.max { |x| x.discount if x }.try(:discount) if special }
  end

  def today_discount_with_time(time)
    current_day = time.wday
    current_day = PlaceUtils::PlaceTime.wday(current_day)
    time = time.strftime("%H:%M").gsub(":",".").to_f
    week_day = WeekDay.with_place_and_day(id, current_day).first
    DayDiscount.with_day_and_time(week_day.id, time)
  end

  def meta_tag
    {title: title, town: location.try(:city), place_url: place_path, place_img: place_image.try{|image| image.url(:place_show)},
     place_address: address, house_number: location.try(:house_number), max_percent_number: max_discount.try(:to_i)
    }
  end

  def place_path
    if location && location.city
      "/#{I18n.locale}/#{slug}-#{location.city_en.downcase.gsub(' ', '_')}"
    else
      "/#{I18n.locale}/#{slug}"
    end
  end

  private

  def self.get_star_rating place
  "left: #{place["overall_mark"] * 20}%" if place["overall_mark"].present?
  end

  def self.en_to_time(time)
    if time.include?("AM")
      time = time.gsub(" AM",'')
    elsif time.include?("PM")
      time = time.gsub(" PM",'').split(":")
      if time[0].to_i != 12
        time[0] = (time[0].to_i + 12).to_s
      end
      time = time.join(":")
    end
    time
  end



  def self.today_discount(discounts, options={})
    if options[:reserve_time].present?
      time = options[:reserve_time].to_s
      time = self.en_to_time(time).sub(":",".").to_f
    else
      time = nil
    end
    current_day = options[:reserve_date].present? ? DateTime.parse(options[:reserve_date]).wday : DateTime.now.wday
    current_day = PlaceUtils::PlaceTime.wday(current_day)
      discounts = discounts.select do |discount|
        if time
          discount["day"] == current_day && time > discount["from_time"].to_f && time <  discount["to_time"].to_f
        else
          discount["day"] == current_day
        end
      end
    discounts = discounts.group_by{|arr| arr["is_discount"]}
    [discounts[true].try(:first), discounts[false]]
  end


  def self.case_order(type)
    case type.to_sym
      when :newest
        "created_at"
      when :overall_mark
        "overall_mark"
      when :discount
        "discount"
      when :reserving
        "reserving"
      else
        "overall_mark"
    end
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

