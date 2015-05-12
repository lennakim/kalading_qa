class AddExpireAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :expire_at, :datetime
    add_column :questions, :engineer_race_count, :integer, default: 0
    add_index :questions, [:state, :expire_at]
  end
end
