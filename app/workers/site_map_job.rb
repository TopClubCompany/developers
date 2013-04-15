# -*- encoding : utf-8 -*-
class SiteMapJob
  @queue = :low

  def self.perform
    site_map_task = 'sitemap:refresh'
    Rails.application.load_tasks unless Rake::Task.task_defined?(site_map_task)
    Rake::Task[site_map_task].invoke
  end
end