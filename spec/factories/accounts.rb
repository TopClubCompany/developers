# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  provider      :string(100)      not null
#  name          :string(255)
#  nickname      :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  phone         :string(255)
#  photo         :string(255)
#  url           :string(255)
#  address       :string(255)
#  language      :string(255)
#  birthday      :string(255)
#  token         :string(255)
#  refresh_token :string(255)
#  secret        :string(255)
#  gender        :integer          default(2)
#  uid           :string(255)      not null
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  idx_accounts_provider_uid  (provider,uid)
#  index_accounts_on_email    (email)
#  index_accounts_on_user_id  (user_id)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
  end
end
