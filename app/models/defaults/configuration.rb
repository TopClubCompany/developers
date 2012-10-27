require 'configatron'

class Configuration
  attr_accessor :data, :file

  def initialize
    @file = Rails.root.join('config', 'environments', "#{Rails.env}.yml")
    @data = YAML.load_file(@file)
  end

  def save(new_hash)
    @data.deep_merge!(new_hash)
    begin
      File.open(@file, 'w') { |file| file.write @data.to_yaml }
    rescue Exception => e
      return false
    end
  end

  def self.load_env_conf
    conf = new
    configatron.configure_from_hash conf.data
    configatron
  end

end


