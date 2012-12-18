# -*- encoding : utf-8 -*-
class AutocompleteApp
  def self.call(env)
    params = Rack::Request.new(env).params
    session = env['rack.session']

    params['q'] = '' unless params['q']

    #options[:order] = "overall_mark"
    #options[:sort_mode] = "desc"
    options[:title] = params['q']
    options[:city] = (session['city'] || 'kyiv')

    result = Place.search(options)
    result.map{|e| Place.for_autocomplite(e)}

    [200, {"Content-Type" => "application/json"}, result.map{|e| Place.for_autocomplite(e)}]

  end


end