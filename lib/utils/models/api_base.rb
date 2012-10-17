## -*- encoding : utf-8 -*-
#require 'digest/sha1'
#module Utils::Models
#  class RecordNotFound < StandardError; end
#
#  class ApiBase < Hashie::Mash
#
#    class << self
#
#      def find(id)
#        return nil unless id
#        record = all.find { |f| f.id == id.to_i }
#        #raise RecordNotFound, "No record exists with the ID #{id}" if record.nil?
#        record
#      end
#
#    end
#
#    #property :id, :required => true
#
#    def to_param
#      self.id.to_s
#    end
#
#  protected
#
#    def self.cached_fetch(suffix=nil, options={}, &block)
#      key = Digest::SHA1.hexdigest("#{self.name.downcase}:#{suffix}_#{options.hash}")
#      Rails.cache.fetch(key, :expires_in => configatron.api.cache_period, &block)
#    end
#  end
#
#  def self.expire_all(suffix=nil)
#    key = Digest::SHA1.hexdigest("#{self.name.downcase}:#{suffix}")
#    Rails.cache.delete(key)
#  end
#end
