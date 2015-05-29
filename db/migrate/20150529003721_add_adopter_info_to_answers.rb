class AddAdopterInfoToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :adopter_id, :string
    add_column :answers, :adopter_type, :string
  end
end
