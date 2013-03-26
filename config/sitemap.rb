# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://topreserve.com.ua"
SitemapGenerator::Sitemap.ping_search_engines

SitemapGenerator::Sitemap.create do
  def with_locale
    Globalize.available_locales.each do |locale|
      yield(locale)
    end
  end

  #places

  Place.find_each do |place|
    with_locale do |locale|
      if locale.to_sym == :ru
        add  place.place_path_without_locale, :lastmod => place.updated_at
      else
        add "/#{locale.to_s}" + place.place_path_without_locale, :lastmod => place.updated_at
      end
    end
  end

  #search category
  Category.main_page_categories.each do |category|
    with_locale do |locale|
      if locale.to_sym == :ru
        add  "/search/#{category.slug}", :lastmod => category.updated_at
      else
        add "/#{locale.to_s}" + "/search/#{category.slug}", :lastmod => category.updated_at
      end
    end
  end

end

