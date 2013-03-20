namespace :carrierwave do
  desc "rake carrierwave:reprocess CLASS=InfoPic ASSOC=photo\n
        rake carrierwave:reprocess CLASS=Photo"
  task :reprocess => :environment do
    klass = ENV['CLASS'].camelize.constantize
    assoc = ENV['ASSOC']

    puts klass
    puts assoc

    klass.all.each do |record|
      if assoc
        objects = Array(record.send(assoc))
      else
        objects = Array(record)
      end

      objects.each do |object|
        begin
          object.data.recreate_versions!
        rescue
          p object
        end
      end
    end
  end
end