# -*- encoding : utf-8 -*-
class ElasticIndexerJob
  @queue = :low

  def self.perform
    tire_task = 'tire:im'
    Rails.application.load_tasks unless Rake::Task.task_defined?(tire_task)
    Rake::Task[tire_task].invoke
  end
end