class PlaceFeatureApp
  def self.call(env)
    params = Rack::Request.new(env).params
    feature_items = GroupFeature.place_feature_groups(params['place_id'], params['category_id']).uniq
    [200, {"Content-Type" => "application/json"}, feature_items.map{|feature_item| {name: feature_item.name,
                                                                                    id: feature_item.id
                                                                                    }}.to_json ]
  end
end