class AddPhoneCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_code_id, :integer
  end
end
