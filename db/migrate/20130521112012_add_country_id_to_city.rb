class AddCountryIdToCity < ActiveRecord::Migration
  def change
    add_column :cities, :country_id, :integer
    add_index :cities, :country_id
  end

end
