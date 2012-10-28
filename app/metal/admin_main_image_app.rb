class AdminMainImageApp
  def self.call(env)
    params = Rack::Request.new(env).params
    if new_main_asset_id = params['new_main_id'].presence
      Asset.find(new_main_asset_id).update_attribute(:is_main, true)
    end
    if old_main_asset_id = params['old_main_id'].presence
      Asset.find(old_main_asset_id).update_attribute(:is_main, false)
    end
    [200, {"Content-Type" => "application/json"}, {}]
  end
end