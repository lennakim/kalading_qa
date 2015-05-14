class AddQuestionImagesToQuestionBases < ActiveRecord::Migration
  def change
    add_column :question_bases, :question_images, :text
  end
end
