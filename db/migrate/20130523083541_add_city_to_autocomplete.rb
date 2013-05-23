class AddCityToAutocomplete < ActiveRecord::Migration
  def change
    add_column :autocompletes, :city, :string
  end
end
