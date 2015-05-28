class ChangeIndexOfQuestions < ActiveRecord::Migration
  def up
    remove_index :questions, :customer_id
    add_index :questions, [:customer_id, :created_at]
  end

  def down
    remove_index :questions, [:customer_id, :created_at]
    add_index :questions, :customer_id
  end
end
