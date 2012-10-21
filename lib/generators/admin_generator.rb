# -*- encoding : utf-8 -*-
class AdminGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates/admin", __FILE__)
  desc "generate admin_resource"

  argument :model_name, :type => :string, :required => true
  class_option :no_form, :type => :boolean, :default => false, :description => "Don't create form template"#, :aliases => '-r'
  class_option :no_table, :type => :boolean, :default => false, :description => "Don't create table template"
  class_option :no_search_form, :type => :boolean, :default => false, :description => "Don't create search_form template"

  def create_controller_files
    template "controller.erb", File.join('app/controllers/admin', "#{controller_file_name}_controller.rb")
    template "helper.rb", File.join('app/helpers/admin', "#{controller_file_name}_helper.rb")
  end

  def create_views_files
    template('form.erb', "app/views/admin/#{controller_file_name}/_form.html.haml") unless options.no_form?
    template('table.erb', "app/views/admin/#{controller_file_name}/_table.html.haml") unless options.no_table?
    template('search_form.erb', "app/views/admin/#{controller_file_name}/_search_form.html.haml") unless options.no_search_form?
  end

  def model_key
    @model_key ||= model_class.model_name.i18n_key.to_s
  end

  def model_class
    @model_class ||= model_name.camelcase.constantize
  end

  def model
    @model ||= model_class.new
  end

  def controller_class_name
    @controller_class_name ||= model_class.model_name.plural.camelize
  end

  def controller_file_name
    @controller_file_name ||= model_class.model_name.plural
  end

  def translated_columns
    @translated_columns ||= model_class.translated_attribute_names if model_class.respond_to?(:translated_attribute_names)
    @translated_columns ||= []
  end

end
