class CityToAccounts < ActiveRecord::Migration
  def up
    add_column :users, :city, :string
  end

  def down
    remove_column :users, :address
  end
end
