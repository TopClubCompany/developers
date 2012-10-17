# -*- encoding : utf-8 -*-
Dir["#{File.dirname(__FILE__)}/core_ext/*.rb"].sort.each do |path|
  require "utils/core_ext/#{File.basename(path, '.rb')}"
end
