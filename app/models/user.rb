class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  validates :phone_num, presence: true, uniqueness: true
  validates_presence_of :role, :internal_id

  ROLES = %w[dispatcher engineer expert]

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end
end
