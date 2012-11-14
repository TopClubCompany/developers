require 'spec_helper'

describe AccountEmailConfirmation do
  pending "add some examples to (or delete) #{__FILE__}"
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

