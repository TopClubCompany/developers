# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string(20)
#  user_role_id           :integer          default(1)
#  trust_state            :integer          default(1)
#  first_name             :string(255)
#  last_name              :string(255)
#  patronymic             :string(255)
#  phone                  :string(255)
#  address                :string(255)
#  gender                 :integer          default(2)
#  birthday               :date
#  account_id             :integer
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  password_salt          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token                       (confirmation_token) UNIQUE
#  index_users_on_email_and_account_id                     (email,account_id)
#  index_users_on_last_name_and_first_name_and_patronymic  (last_name,first_name,patronymic)
#  index_users_on_login                                    (login)
#  index_users_on_reset_password_token                     (reset_password_token) UNIQUE
#


FactoryGirl.define do
  sequence(:email) { |n| "email#{n}@factory.com" }

  factory :user do
    email
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    password   { Rails.env.production? ? Devise.friendly_token.first(6) : (1..6).to_a.join }
  end

  trait :admin do
    user_role_id  UserRoleType.admin.id
    login 'admin'
  end

  trait :default do
    user_role_id UserRoleType.default.id
    login 'user'
  end

end
