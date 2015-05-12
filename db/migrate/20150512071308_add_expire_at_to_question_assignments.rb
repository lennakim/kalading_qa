class AddExpireAtToQuestionAssignments < ActiveRecord::Migration
  def change
    add_column :question_assignments, :expire_at, :datetime
    add_column :question_assignments, :answered_at, :datetime
    add_index :question_assignments, [:state, :expire_at]
  end
end
