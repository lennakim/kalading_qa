class AddAutoModels < ActiveRecord::Migration
  def change
    create_table :auto_brands do |t|
      t.string :name, null: false
      t.string :internal_id, null: false

      t.timestamps
    end
    add_index :auto_brands, :internal_id

    create_table :auto_models do |t|
      t.string :name, null: false
      t.string :internal_id, null: false
      t.integer :auto_brand_id, null: false

      t.timestamps
    end
    add_index :auto_models, :internal_id
    add_index :auto_models, :auto_brand_id

    create_table :auto_submodels do |t|
      t.string :name, null: false
      t.string :full_name, null: false
      t.string :internal_id, null: false
      t.integer :auto_model_id, null: false

      t.timestamps
    end
    add_index :auto_submodels, :internal_id
    add_index :auto_submodels, :auto_model_id

    rename_column :questions, :auto_brand_id, :auto_brand_internal_id
    rename_column :questions, :auto_model_id, :auto_model_internal_id
    rename_column :questions, :auto_submodel_id, :auto_submodel_internal_id

    rename_column :question_bases, :auto_brand_id, :auto_brand_internal_id
    rename_column :question_bases, :auto_model_id, :auto_model_internal_id
    rename_column :question_bases, :auto_submodel_id, :auto_submodel_internal_id

  end
end
