class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :provider, :limit => 100, :null => false
      t.string :name
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :photo
      t.string :url
      t.string :address
      t.string :language
      t.string :birthday
      t.string :token
      t.string :refresh_token
      t.string :secret

      t.integer :gender, :limit => 1, :default => 2
      t.integer :uid, :limit => 8, :null => false

      t.references :user

      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :email
    add_index :accounts, [:provider, :uid], :name => "idx_accounts_provider_uid"
  end

end