module FriendlyId
  module Slugged
    def normalize_friendly_id(value)
      Utils::I18none::Alphavit.to_en(value.to_s).parameterize
    end
  end
end