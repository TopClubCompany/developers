class AddIsNoiseToMarkTypes < ActiveRecord::Migration
  def change
    add_column :mark_types, :is_noise, :boolean, default: false
  end
end
