class AddCityInternalIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city_internal_id, :string
  end
end
