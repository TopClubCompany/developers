class Array
  def word_count
    each_with_object({}) do |word, h|
      h[word] ||= 0
      h[word] += 1
    end
  end

  def deep_merge_hashes
    self.inject({}) do |res, h|
      raise Exception.new("Not a hash #{h}") unless h.is_a?(Hash)
      h.deep_merge(res)
    end
  end

  def mean
    return 0 if size == 0
    inject(:+) / size
  end

  def zip_all
    self[0].zip *self[1..-1]
  end

  def safe_sd
    begin
      self.to_scale.sd
    rescue
      0.0
    end
  end

  def pearson(b)
    return 0 if self.size != b.size || !Object.const_defined?("Statsample")
    Statsample::Bivariate.pearson(self.to_scale, b.to_scale)
  end

  def pluck!(method, *args)
    each_index { |x| self[x] = self[x].send method, *args }
  end

  alias invoke! pluck!

  def without(*values)
    copy = self.dup
    values.flatten.each { |value| copy.delete(value) }
    copy
  end

  def without!(*values)
    values.flatten.each { |value| self.delete(value) }
    self
  end

  def map_val(attr='id')
    map{|el| el[attr] }
  end

  def contain?(other)
    (other - self).empty?
  end

  def intersect?(other)
    !(self & other).empty?
  end

  def to_hash
    h = {}
    each { |k, v| h[k] = v }
    h
  end

end

module Enumerable
  def pluck(method, *args)
    map { |x| x.send method, *args }
  end

  alias invoke pluck
end

