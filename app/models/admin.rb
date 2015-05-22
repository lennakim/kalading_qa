class Admin < ActiveRecord::Base
  devise :database_authenticatable, :lockable, :timeoutable,
         :rememberable, :trackable, :validatable, authentication_keys: [:email]
end
