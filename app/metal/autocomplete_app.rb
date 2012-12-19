# -*- encoding : utf-8 -*-
class AutocompleteApp
  def self.call(env)
    params = Rack::Request.new(env).params
    session = env['rack.session']

    params['q'] = '' unless params['q']
    options = {}

    #options[:order] = "overall_mark"
    #options[:sort_mode] = "desc"
    options[:title] = params['q']
    options[:per_page] = params['per_page'] if params['per_page'].present?
    options[:city] = (session['city'] || 'kyiv')

    result = Place.search(options)

    [200, {"Content-Type" => "application/json"}, result.map{|e| Place.for_autocomplite(e)}.to_json]

  end


end