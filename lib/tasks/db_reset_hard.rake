desc "db:drop db:create db:migrate db:seed"

namespace :db do
  namespace :reset do
    task :hard, %w|db:drop db:create db:migrate db:seed| => :environment do
      puts "db reset successfully"
    end
  end
end