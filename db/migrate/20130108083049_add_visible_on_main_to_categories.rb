class AddVisibleOnMainToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :is_visible_on_main, :boolean, default: false
  end
end
