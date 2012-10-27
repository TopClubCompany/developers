if Rails.env.development?
  namespace :db do
    task :migrate do
      Annotate::Migration.update_annotations
    end

    namespace :migrate do
      [:change, :up, :down, :reset, :redo].each do |t|
        task t do
          Annotate::Migration.update_annotations
        end
      end
    end
  end

  module Annotate
    class Migration
      @@working = false

      def self.update_annotations
        unless @@working || (ENV['skip_on_db_migrate'] =~ /(true|t|yes|y|1)$/i)
          @@working = true
          Rake::Task['annotate_models'].invoke
        end
      end
    end
  end
end
