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
    BillType.find(avg_id).title rescue ''
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
    if param_time.split(":")[0].size < 2
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

end