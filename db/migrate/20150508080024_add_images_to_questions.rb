class AddImagesToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :images, :text
  end
end
