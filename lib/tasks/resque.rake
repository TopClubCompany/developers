# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'resque/pool/tasks'

task "resque:setup" => :environment do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
end

task "resque:pool:setup" do
  require 'resque/pool'
  # close any sockets or files in pool manager
  ActiveRecord::Base.connection.disconnect!
  # and re-open them in the resque worker parent
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
  end
end

desc 'clear your failure queue in resque.  good for crons.'
task 'resque:clear_failed' => :environment do
  puts "clearing resque failures"
  Resque::Failure.clear
  puts "complete!"
end

desc "Clear pending tasks"
task 'resque:clean' => :environment do
  queues = Resque.queues
  queues.each do |queue_name|
    puts "Clearing #{queue_name}..."
    Resque.redis.del "queue:#{queue_name}"
  end

  puts "Clearing delayed..." # in case of scheduler - doesn't break if no scheduler module is installed
  Resque.redis.keys("delayed:*").each do |key|
    Resque.redis.del "#{key}"
  end
  Resque.redis.del "delayed_queue_schedule"

  puts "Clearing stats..."
  Resque.redis.set "stat:failed", 0
  Resque.redis.set "stat:processed", 0
end