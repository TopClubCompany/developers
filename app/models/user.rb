class User < ActiveRecord::Base

  devise :database_authenticatable, :confirmable, :lockable,
         :rememberable, :trackable, :validatable, :registerable, :recoverable,
         :encryptable, :encryptor => :sha512



  attr_accessible :login, :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :patronymic, :phone, :address, :birthday, :user_type_id


  has_many :reviews

end
