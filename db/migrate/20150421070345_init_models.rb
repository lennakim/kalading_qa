class InitModels < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :question_category_id
      t.string :auto_brand_id
      t.string :auto_model_id
      t.string :auto_submodel_id
      t.integer :customer_id
      t.text :content
      t.string :status

      t.timestamps
    end
    add_index :questions, :customer_id
    add_index :questions, [:status, :created_at]

    create_table :answers do |t|
      t.integer :question_id
      t.string :replier_id
      t.string :replier_type
      t.text :content

      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :replier_id

    create_table :question_category do |t|
      t.string :name

      t.timestamps
    end

    create_table :question_bases do |t|
      t.integer :question_category_id
      t.string :auto_brand_id
      t.string :auto_model_id
      t.string :auto_submodel_id
      t.text :question_content
      t.text :answer_content

      t.timestamps
    end
  end
end
