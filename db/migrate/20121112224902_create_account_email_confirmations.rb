class CreateAccountEmailConfirmations < ActiveRecord::Migration
  def change
    create_table :account_email_confirmations do |t|

      t.string :confirmation_token, unique: true
      t.string :unconfirmed_email

      t.datetime :confirmed_sent_at
      t.datetime :confirmed_at

      t.references :account

      t.integer  :failed_attempts, default: 0

      t.timestamps
    end
    add_index :account_email_confirmations, :confirmation_token
    add_index :account_email_confirmations, :account_id
  end
end
