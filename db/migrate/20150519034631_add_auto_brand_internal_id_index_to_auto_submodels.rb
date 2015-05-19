class AddAutoBrandInternalIdIndexToAutoSubmodels < ActiveRecord::Migration
  def change
    add_index :auto_submodels, :auto_brand_internal_id
  end
end
