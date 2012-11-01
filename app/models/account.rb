# -*- encoding : utf-8 -*-
class Account < ::ActiveRecord::Base

  belongs_to :user

  validates_presence_of :provider, :uid

  attr_accessible :provider, :uid, :name, :first_name, :last_name, :email, :photo,
                  :gender, :address, :language, :birthday, :url, :banned_at, :phone, :nickname,
                  :token, :refresh_token, :secret, :user

  enumerated_attribute :gender_type, :id_attribute => :gender, :class => ::GenderType


  def self.create_or_find_by_oauth_token access_token#, provider

    account = Account.find_or_create_by_url( url: access_token.info.urls.Facebook, nickname: access_token.extra.raw_info.username,
                                             email: access_token.extra.raw_info.email,provider: access_token.provider,
                                             user: prepare_user_for_account(generate_user_email(url)) )
    account.user
  end


  def prepare_user_for_account(email)
    password            = Devise.friendly_token[0,20]
    user                = User.new(email: email, password: password, password_confirmation: password)
    user.user_role_type = UserRoleType.default
    user.trust_state    = UserState.active.id

    user.skip_confirmation!
    user.save!
  end

  def generate_user_email(user_info)

  end

end
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
#  uid           :integer          not null
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

