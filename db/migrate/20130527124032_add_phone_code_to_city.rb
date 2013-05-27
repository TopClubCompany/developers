class AddPhoneCodeToCity < ActiveRecord::Migration
  def change
    add_column :cities, :phone_code, :string
  end
end
