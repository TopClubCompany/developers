desc "db:drop db:create db:migrate db:seed"

namespace :db do
    task :make => :environment do
      %w|db:drop db:create db:migrate db:seed|.each { |t|  Rake::Task[t].invoke}
      puts "db reset successfully"
    end
end