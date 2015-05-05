class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  validates_presence_of :phone_num, :role

  ROLES = %w[dispatcher engineer expert]

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end
end
