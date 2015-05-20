class AddCanBeRacedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :can_be_raced, :boolean
    add_index :questions, :can_be_raced
  end
end
