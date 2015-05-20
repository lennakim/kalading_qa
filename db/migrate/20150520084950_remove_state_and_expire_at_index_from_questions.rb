class RemoveStateAndExpireAtIndexFromQuestions < ActiveRecord::Migration
  def up
    remove_index :questions, [:state, :expire_at]
  end

  def down
    add_index :questions, [:state, :expire_at]
  end
end
