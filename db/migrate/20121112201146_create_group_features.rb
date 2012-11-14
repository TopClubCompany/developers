class CreateGroupFeatures < ActiveRecord::Migration
  def change
    create_table :group_features do |t|
      t.boolean :is_visible, :default => true

      t.timestamps
    end
  end
end
