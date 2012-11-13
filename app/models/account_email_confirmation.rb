class AccountEmailConfirmation < ActiveRecord::Base
  attr_accessible :confirmation_token, :confirmed_at, :confirmed_sent_at, :unconfirmed_email, :failed_attempts
  has_one :account

  def self.check_token(token)
    result = find_by_confirmation_token(token)

    if (Time.now.to_i - result.confirmed_sent_at.to_i) < 7200
      confirm_account(result.account)
    end if result

  end

  def self.generate_email_confirm(email, data)
    conf = create(confirmation_token: Devise.friendly_token, confirmed_sent_at: Time.now, unconfirmed_email: email, )
    conf.account = fill_unconfirmed_account(data)
    conf.save!
  end

  private

  def self.fill_unconfirmed_account(data)
    data = data.except(:email, :patronymic)
    Account.create(data)
  end

  def self.confirm_account(account)

  end

end
# == Schema Information
#
# Table name: account_email_confirmations
#
#  id                 :integer          not null, primary key
#  confirmation_token :string(255)
#  unconfirmed_email  :string(255)
#  confirmed_sent_at  :datetime
#  confirmed_at       :datetime
#  account_id         :integer
#  failed_attempts    :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_account_email_confirmations_on_account_id          (account_id)
#  index_account_email_confirmations_on_confirmation_token  (confirmation_token)
#

