#coding: utf-8
module PlacesHelper

  def parse_filters_from options
    if options[:what].nil? or options[:what].size < 1
      return options
    end

    filters = []
    words = options[:what].split(' ')
    words.reject!{|word| Tire.russian_stopwords.include?(word) or word.length < 3 }
    words.each do |word|
      res = Filter.find(word)
      unless res.empty?
        filters += res
        options[:what].gsub!(word,'')
      end
    end

    options[:what] = options[:what].split(' ')
    options[:what] = options[:what].reject{|word| Tire.russian_stopwords.include?(word) or word.length < 3 }
    options[:what] = options[:what].join(' ')
    filters.each do |f|
      options[ f[:type].to_sym ] = { f[:value].to_s => f[:value].to_s }
    end
    options
  end

  def get_star_rating place
    "left: #{place.overall_mark * 20}%" if place.try(:overall_mark)
  end

  def avg_bill_title avg_id
    Place.avg_bill_title(avg_id, current_city) || ""
  end

  def get_pricing place
    count_of_diff_prices = BillType.all.count
    price_bill = place.bill.try(:id).to_i.times.map {"$"}.join('')
    result = content_tag :strong, price_bill.to_s
    left_price = (count_of_diff_prices - @place.bill.try(:id).to_i).times.map {"$"}.join('')
    result + left_price
  end

  def get_pricing_without_left place
    price_bill = place.bill.try(:id).to_i.times.map {"$"}.join('')
    content_tag :strong, price_bill.to_s
  end

  def get_time_class time, param_time
    param_time = to_en_time(param_time)
    if param_time.split(":")[0].size < 2 && (I18n.locale.to_sym != :en)
      param_time = "0"+param_time
    end
    if time[:available]
      if param_time == time[:time].to_s
        'bold'
      else
        ''
      end
    else
      'na'
    end
  end


  def group_discounts(special_offers, nested = true)
    result = {}
    grouped_by_title = special_offers.group_by {|offer| "#{offer.title}, #{offer.discount}"}
    compacted_offers = grouped_by_title.map do |different_offer_key, different_offer_offers|
      initial_key = chain_day_names(different_offer_offers.inject([]){|memo, offer| memo << offer.week_day.day_type.title})
      grouped_by_time = different_offer_offers.group_by {|offer| "#{offer.from_time}, #{offer.to_time}"}
      res = grouped_by_time.map do |time, offers|
        secondary_key = chain_day_names(offers.inject([]){|memo, offer| memo << offer.week_day.day_type.title})
        Hash[time, secondary_key]
      end
      offer_description = Hash[different_offer_offers.uniq_by {|offer| "#{offer.title}, #{offer.discount}"}, Hash[initial_key, res]]
    end
  end

  def chain_day_names days_to_chain
    day_names = DayType.all.map {|day| day.title}
    res = days_to_chain.inject('') do |current_scope, current|
      current_scope << (if current_scope =~ /[А-Яа-яA-Za-z]$|-$/
          # we are in open scope we either prolong it or close
          previous_day = current_scope.split(/,|-/).compact[-1]
          if !previous_day.nil? and  day_names.index(previous_day) + 1 == (day_names.index(current))
            '-' + current
          else
            ',' + current
          end
        else
          # it was either , or empty
          ',' + current
        end)
      current_scope.sub!(/^,/, '')
      current_scope.sub!(/-[А-Яа-яA-Za-z]+-/, '-')
      current_scope
    end
    res
  end

end

