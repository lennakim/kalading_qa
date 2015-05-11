class AddInternalIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :internal_id, :string, null: false
    add_index :users, :internal_id
  end
end
