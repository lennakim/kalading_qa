class AddInternalForeignKeyToAutos < ActiveRecord::Migration
  def up
    rename_column :auto_models, :auto_brand_id, :auto_brand_internal_id
    change_column :auto_models, :auto_brand_internal_id, :string, null: false

    rename_column :auto_submodels, :auto_model_id, :auto_model_internal_id
    change_column :auto_submodels, :auto_model_internal_id, :string, null: false

    add_column :auto_submodels, :auto_brand_internal_id, :string, null: false
  end

  def down
    change_column :auto_models, :auto_brand_internal_id, :integer, null: false
    rename_column :auto_models, :auto_brand_internal_id, :auto_brand_id

    change_column :auto_submodels, :auto_model_internal_id, :integer, null: false
    rename_column :auto_submodels, :auto_model_internal_id, :auto_model_id

    remove_column :auto_submodels, :auto_brand_internal_id
  end
end
