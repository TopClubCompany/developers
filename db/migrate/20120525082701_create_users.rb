# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :login, :limit => 20#, :null => false
      t.integer :user_role_id, :limit => 1, :default => 1
      t.integer :trust_state, :limit => 1, :default => 1
      t.string :first_name
      t.string :last_name
      t.string :patronymic
      t.string :phone
      t.string :address
      t.integer :gender, :limit => 1, :default => 2
      t.date :birthday

      t.references :account

      ## Database authenticatable
      t.string :email
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Encryptable
      t.string :password_salt

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Token authenticatable
      # t.string :authentication_token

      t.timestamps
    end

    add_index :users, [:email, :account_id]#, :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token, :unique => true
    add_index :users, :login #,                :unique => true
    add_index :users, [:last_name, :first_name, :patronymic]
  end

  def self.down
    drop_table :users
  end
end
