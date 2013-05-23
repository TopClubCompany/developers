class Autocomplete < ActiveRecord::Base

  elasticsearch

  def to_indexed_json
    {:term => term, :freq => freq}.to_json
  end

  def self.search(query)
    return [] if query.blank?
    tire.search :per_page => 30 do
      query { match :term, query.lucene_escape, 'type' => 'phrase_prefix' }
      sort { by 'freq', 'desc' }
    end.map(&:term).uniq
  end

  def self.perform
    columns = [:term, :freq]
    words = []

    Autocomplete.full_truncate


    [[Place, :name]].each do |m|
      words += m[0].build_stops(m[0].const_get(:Translation).value_of(m[1]).join(' '))
    end

    [[Location, :street],[Location, :city], [Location, :county], [Location, :country]].each do |m|
      words += m[0].const_get(:Translation).value_of(m[1])
    end

    import(columns, words.compact.word_count.to_a)
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
#

