require 'bundler/capistrano'

set :application, "topclub"

set :scm, :git

set :repository,  "git@github.com:roundlake/topclub.git"
set :deploy_to, "/home/deployer/www/topclub.rdlk.biz"

set :use_sudo, false
set :user, "deployer"

role :app, "topclub-dev1.rdlk.net"
role :web, "topclub-dev1.rdlk.net"
role :db,  "topclub-dev1.rdlk.net", :primary => true

set :keep_releases, 1

before :"deploy:symlink", :"deploy:assets"

namespace :deploy do
  task :assets do
    run "cd #{release_path}; bundle exec rake assets:precompile RAILS_ENV=production"
  end

  task :install do
    run "rm -f #{current_path}/db/production.sqlite3"
    run "cd #{current_path}; bundle exec rake db:install NO_BUS_ACCESS=1 RAILS_ENV=production"
    run "mv #{current_path}/db/production.sqlite3 #{shared_path}/production.sqlite3"
    run "ln -nfs #{shared_path}/production.sqlite3 #{current_path}/db/production.sqlite3"
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :finalize_update do
    run "mkdir #{release_path}/tmp"
    run "ln -nfs #{shared_path}/system #{release_path}/public/system"
    run "ln -nfs #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end