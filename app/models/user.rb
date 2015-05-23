class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  has_and_belongs_to_many :roles, join_table: 'user_roles'

  validates :phone_num, presence: true, uniqueness: true
  validates_presence_of :internal_id

  def self.dispatchers
    Role.where(name: 'dispatcher').first.users
  end

  def self.specialists
    Role.where(name: 'specialist').first.users
  end

  def self.be_able_to_sign_in
    joins(:roles).where('roles.name' => Role::SIGN_IN_ROLES)
  end

  def role_list
    @role_list ||= roles.pluck(:name)
  end

  def assign_roles(*role_names)
    _roles = Role.where(name: role_names.flatten).all
    self.roles = _roles if _roles.present?
  end

  def has_role?(*role_names)
    role_names.flatten.any? do |role_name|
      role_list.include?(role_name.to_s)
    end
  end

  def be_able_to_sign_in?
    has_role?(Role::SIGN_IN_ROLES)
  end
end
