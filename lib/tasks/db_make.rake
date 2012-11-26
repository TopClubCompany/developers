desc "db:drop db:create db:migrate db:seed"

namespace :db do
    task :make => :environment do
      Rake::Task['db:drop'].invoke
      Rake::Task["db:create"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["db:seed"].invoke
      puts "db reset successfully"
    end
end