class RenameUserRoleToHandler < ActiveRecord::Migration
  def change
    rename_column :question_assignments, :user_role, :handler
  end
end
