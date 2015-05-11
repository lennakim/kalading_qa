class CreateQuestionAssignments < ActiveRecord::Migration
  def change
    create_table :question_assignments do |t|
      t.integer :question_id, null: false
      t.string :user_internal_id, null: false
      t.string :user_role, null: false
      t.string :state, null: false

      t.timestamps
    end
    add_index :question_assignments, [:question_id, :state]
    add_index :question_assignments, [:user_internal_id, :state]
  end
end
