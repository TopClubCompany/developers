class AddCssClassToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :css_id, :string
  end
end
