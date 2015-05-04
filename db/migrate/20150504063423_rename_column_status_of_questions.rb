class RenameColumnStatusOfQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :status, :state
  end
end
