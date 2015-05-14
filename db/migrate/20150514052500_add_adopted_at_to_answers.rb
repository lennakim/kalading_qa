class AddAdoptedAtToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :adopted_at, :datetime
  end
end
