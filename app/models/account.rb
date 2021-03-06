# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
  extend Utils::Auth::SocCallbackParser
  belongs_to :user
  belongs_to :account_email_confirmation

  validates_presence_of :provider, :uid

  attr_accessible :provider, :uid, :name, :first_name, :last_name, :email, :photo,
                  :gender, :address, :language, :birthday, :url, :banned_at, :phone, :nickname,
                  :token, :refresh_token, :secret, :user, :user_id

  enumerated_attribute :gender_type, :id_attribute => :gender, :class => ::GenderType

  scope :by_type, lambda{ |type| where(:provider => type) }

  scope :find_by_uid_and_provider, lambda { |uid, provider| where("uid = ? AND provider = ?", uid, provider) }


  def self.create_or_find_by_oauth_data data
    data = self.check_first_name_last_name(data)
    account = Account.find_by_uid_and_provider(data[:uid], data[:provider]).last
    return account.user if account && account.user
    data_for_account = data.except(:patronymic)
    data_for_user    = data.except(:uid, :url, :photo, :name, :provider, :secret, :refresh_token, :language, :token)
    data_for_user.gender = get_gender(data_for_user.gender, data[:provider])
    user             = User.find_by_email(data[:email])
    account          = Account.create(data_for_account)
    account.user     = (user or prepare_user_for_account(data_for_user))
    account.save!
    account.user
  end


  def self.prepare_user_for_account(data)
    data[:password]     = Devise.friendly_token[0,20]
    user                = User.new(data)
    user.trust_state    = UserState.active.id
    user.generate_default_fields
    user.skip_confirmation!
    user.save!
    user
  end

  def self.check_first_name_last_name(data)
    if data[:name].present?
      data[:first_name] = data[:first_name].present? ? data[:first_name] : data[:name]
      data[:last_name] = data[:last_name].present? ? data[:last_name] : data[:name]
    end
    data
  end


  def create_user_from_account
    data_for_user  = attributes.symbolize_keys.slice(:first_name, :last_name, :email, :address, :phone, :birthday)
    Account.prepare_user_for_account(data_for_user)
  end


  private

  def self.get_gender(gender, provider)
    case provider
      when "facebook"
        GenderType.send(gender).id if gender.present?
      when "vkontakte"
        if gender.present?
          case gender.try(:to_i)
            when 1
              2
            when 2
              1
            else
              3
          end
        end
      else
        gender.try(:to_i) if gender
    end
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

