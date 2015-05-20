class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: 'user_roles'

  validates :name, presence: true, uniqueness: true

  def self.valid_role?(names)
    where(name: names).exists?
  end
end
