class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  validates_presence_of :phone_num, :role
end
