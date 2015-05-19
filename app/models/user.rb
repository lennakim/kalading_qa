class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  validates :phone_num, presence: true, uniqueness: true
  validates_presence_of :role, :internal_id

  ROLES = %w[dispatcher support_manager manager engineer specialist]

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  def self.dispatchers
    where(role: 'dispatcher').all
  end

  def self.specialists
    where(role: 'specialist').all
  end

  def self.valid_role?(role_str)
    role_str.split(',').any? do |r|
      ROLES.include?(r)
    end
  end
end
