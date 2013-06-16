class AddSupportPhoneToCity < ActiveRecord::Migration
  def change
    add_column :cities, :support_phone, :string
  end
end
