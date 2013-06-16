class Autocomplete < ActiveRecord::Base

  elasticsearch

  def to_indexed_json
    {term: term, freq: freq, city: city}.to_json
  end

  def self.search(query, params={})
    return [] if query.blank?
    filters = []
    if params[:city].present?
      filters << {query: {text: {city: params[:city]}}}
    end
    tire.search :per_page => 30 do
      query do
        match :term, query.lucene_escape, 'type' => 'phrase_prefix'
      end

      filter(:and, :filters => filters)
      sort { by 'freq', 'desc' }
      puts to_json
    end.map(&:term).uniq
  end

  def self.perform
    columns = [:term, :city, :freq]
    words = []
    _words = []

    Autocomplete.full_truncate

    Place.with_translations.find_each do |place|
      _words += Globalize.available_locales.map do |locale|
        place.send("name_#{locale}")
      end.zip(Globalize.available_locales.map { |locale| place.get_city(:en) })
    end

    _words.each do |word|
      tmp_words = Place.build_stops(word[0])
      words += tmp_words.zip(tmp_words.map { word[1] })
    end

    [[Location, :street], [Location, :city], [Location, :county], [Location, :country]].each do |m|
      m[0].with_translations.find_each do |obj|
        words += Globalize.available_locales.map do |locale|
          obj.send("#{m[1]}_#{locale}")
        end.zip(Globalize.available_locales.map { |locale| obj.send("city_en") })
      end
    end

    words = words.compact.word_count.map do |obj|
      obj.flatten
    end

    import(columns, words)
    count
  end
end
# == Schema Information
#
# Table name: autocompletes
#
#  id         :integer          not null, primary key
#  term       :string(255)
#  freq       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city       :string(255)
#

