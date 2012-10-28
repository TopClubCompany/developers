# -*- encoding : utf-8 -*-
class AdminAutocompleteApp
  def self.call(env)
    params = Rack::Request.new(env).params
    params['q'] = '' unless params['q']

    raw_klass = params['custom'].try(:fetch, 'class') || params['class']
    klass = Rack::Utils.unescape(raw_klass).safe_constantize
    options = params.slice('with', 'with_all', 'without').symbolize_keys
    attr = params['attr'] || (klass.ac_opts[:localized] ? "#{klass.ac_attr}_#{I18n.locale}" : klass.ac_attr.to_s)

    if ['Catalogue', 'Section', 'PGroup', 'MGroup', 'TagGroup'].include?(klass.name)
      options[:order] = "lft"
      options[:per_page] = 1000
    elsif ['Material', 'Tag'].include?(klass.name)
      options[:order] = "name_#{I18n.locale}"
      options[:order] = "name_#{I18n.locale}"
    elsif ['ContentKind'].include?(klass.name)
      options[:with] = {'is_public' => false}
    else
      options[:order] = "created_at"
      options[:sort_mode] = "desc"
    end

    #if ['Tag'].include?(klass.name)
    #  options[:with] ||= {}
    #  options[:with][:is_visible] = true
    #end

    entries = klass.token_search("#{params['q']}* OR *#{params['q']}*", options).to_a
    entries = klass.token_search(params['q'].split(/\s+/).map { |s| "*#{s}*" }.join(' AND '), options).to_a if entries.empty?
    entries = klass.token_search("*#{params['q'].tr_lang}*", options).to_a if entries.empty?

    if params['token']
      res = entries.map { |r| klass.for_input_token(r, attr) }
    else
      res = {:suggestions => entries.map_val(attr), :data => entries.map_val(:id), :query => params['q']}
    end

    [200, {"Content-Type" => "application/json"}, res.to_json]
  end

  def self.set_locale(params)
    #if params['locale'] && Globalize.available_locales.include?(params['locale'].to_sym)
    #  I18n.locale = params['locale'].to_sym
    #else
    #  I18n.locale = Rails.application.config.i18n.default_locale
    #  #I18n.locale = I18n.default_locale
    #end
    I18n.locale = :ru
  end

end
