class RemoveRoleFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :role
  end

  def down
    add_column :users, :role, :string, null: false
    add_index :users, :role
  end
end