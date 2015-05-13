class AddQuestionStateToQuestionAssignments < ActiveRecord::Migration
  def change
    add_column :question_assignments, :question_state, :string, null: false
  end
end
