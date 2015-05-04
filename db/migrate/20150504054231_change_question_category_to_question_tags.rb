class ChangeQuestionCategoryToQuestionTags < ActiveRecord::Migration
  def change
    drop_table :question_category
    remove_column :questions, :question_category_id
    remove_column :question_bases, :question_category_id

    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :questions_tags, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :tag, index: true
    end

    create_table :question_bases_tags, id: false do |t|
      t.belongs_to :question_base, index: true
      t.belongs_to :tag, index: true
    end
  end
end
