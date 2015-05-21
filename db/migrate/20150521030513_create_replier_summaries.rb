class CreateReplierSummaries < ActiveRecord::Migration
  def change
    create_table :replier_summaries do |t|
      t.string :replier_id, null: false
      t.datetime :month, null: false
      t.integer :answers_count, default: 0
      t.integer :adoptions_count, default: 0
      t.float :bonus, default: 0

      t.timestamps
    end
    add_index :replier_summaries, [:replier_id, :month]
  end
end
