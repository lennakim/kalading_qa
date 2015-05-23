# Roles:
#   dispatcher      客服
#   support_manager 客服主管
#   engineer        技师
#   specialist      专家
#   manager         总裁
class Role < ActiveRecord::Base
  SIGN_IN_ROLES = %w[dispatcher support_manager manager]

  has_and_belongs_to_many :users, join_table: 'user_roles'

  validates :name, presence: true, uniqueness: true

  def self.valid_role?(names)
    where(name: names).exists?
  end
end
