class AddIncludedInOverallToMarkType < ActiveRecord::Migration
  def change
    add_column :mark_types, :included_in_overall, :boolean, default: true
  end
end
