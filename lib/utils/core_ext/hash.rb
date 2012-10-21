class Hash
  def reverse_deep_merge!(other_hash)
    other_hash.each_pair do |k, v|
      tv = self[k]
      self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? v.deep_merge!(tv) : (self[k] || v)
    end
    self
  end

  def self.convert_hash_to_ordered_hash(object)
    if object.is_a?(Hash)
      array = object.to_a
      array.sort! { |a, b| a[0].to_s <=> b[0].to_s }
      array.each_with_object(ActiveSupport::OrderedHash.new) { |v, h| h[v[0]] = convert_hash_to_ordered_hash(v[1]) }
#    elsif object.is_a?(Array)
#      array = Array.new
#      object.each_with_index { |v, i| array[i] = convert_hash_to_ordered_hash(v) }
#      return array
    else
      object
    end
  end

  def deep_clear_values
    self.each_key do |key|
      if self[key].is_a?(Hash)
        self[key] = self[key].deep_clear_values
      else
        self[key] = ''
      end
    end
    self
  end

  def deep_set_key_values
    self.each_key do |key|
      if self[key].is_a?(Hash)
        self[key] = self[key].deep_set_key_values
      else
        self[key] = key.to_s
      end
    end
    self
  end

  def clear_values
    result = {}
    self.each_key do |key|
      result[key] = ''
    end
    result
  end

  def fetch_keys(*hash_keys)
    hash_keys.each_with_index do |k, i|
      if hash_keys[i+1]
        return self[k].fetch_keys(*hash_keys[1..-1])
      else
        return self[k]
      end
    end
  end

  def deep_diff(other_hash)
    other_hash.each_pair do |k, v|
      if self[k].is_a?(Hash) && v.is_a?(Hash)
        self[k] = self[k].deep_diff(v)
        self.delete(k) if self[k].empty?
        self[k]
      else
        self.delete(k)
      end
    end
    self
  end

  def deep_add(other_hash)
    other_hash.each_pair do |k, v|
      tv = self[k]
      if self[k]
        self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_add(v) : v
      end
    end
    self
  end

  def add(other_hash)
    other_hash.each_pair do |k, v|
      self[k] = v if self.keys.include?(k)
    end
  end

  def set_keys(value, *hash_keys)
    hash_keys.each_with_index do |k, i|
      if hash_keys[i+1]
        return self[k].set_keys(value, *hash_keys[1..-1])
      else
        self[k] = Hash.convert_hash_to_ordered_hash(value)
        return self
      end
    end
  end

  def set_keys_eval(value, *hash_keys)
    self.instance_eval("self['#{hash_keys.join("']['")}']=%q[#{Hash.convert_hash_to_ordered_hash(value)}]")
    self
  end

  def val(*array)
    if array.empty?
      self
    else
      key = array.shift
      value = self[key]
      if array.empty?
        value
      elsif value.is_a? Hash
        value.val(*array)
      else
        nil
      end
    end
  end

  def rewrite mapping
    inject({}) do |rewritten_hash, (original_key, value)|
      rewritten_hash[mapping.fetch(original_key, original_key)] = value
      rewritten_hash
    end
  end

  def hash_revert
    r = Hash.new { |h, k| h[k] = [] }
    each { |k, v| r[v] << k }
    r
  end

  def try_keys *keys
    option = last_option keys
    keys.flatten.each do |key|
      return self[key] if self[key]
    end
    return option[:default] if option[:default]
    nil
  end

end
