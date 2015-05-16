class RemoveTags < ActiveRecord::Migration
  def change
    drop_table :tags
    drop_table :question_bases_tags
    drop_table :questions_tags
  end
end
