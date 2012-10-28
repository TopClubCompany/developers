namespace :tire do
  task :im => :environment do
    require "globalize_no_query_on_missing"
    Category.default_scopes = [Category.includes(:translations)]

    if ENV['CLASSES']
      models = ENV['CLASSES'].split(',')
    else
        models = Utils::Elastic::Base.tire_models.map(&:name)
    end

    ENV['FORCE'] = 'true' if ENV['FORCE'] || Rails.env.development?

    models.each do |m|
      ENV['CLASS'] = m
      Rake::Task['tire:import'].reenable
      Rake::Task['tire:import'].invoke
    end
  end
end

