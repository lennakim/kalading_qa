class AddUpdatedAtIndexToQuestionAssignments < ActiveRecord::Migration
  def up
    remove_index :question_assignments, column: [:user_internal_id, :state]
    add_index :question_assignments, [:user_internal_id, :state, :updated_at], name: 'idx_q_assignments_on_internal_id_and_state_and_updated_at'
  end

  def down
    remove_index :question_assignments, name: 'idx_q_assignments_on_internal_id_and_state_and_updated_at'
    add_index :question_assignments, [:user_internal_id, :state]
  end
end
