class PlaceFeatureApp
  def self.call(env)
    params = Rack::Request.new(env).params
    feature_items = GroupFeature.place_feature_groups(params['place_id'], params['category_id'])
    res = feature_items.map do |k,v|
      {name: k[0],
       id: k[1],
       items: v.map{|feature_item| {name: feature_item.name, id: feature_item.id}}
      }
    end

    [200, {"Content-Type" => "application/json"}, res.to_json]
  end
end