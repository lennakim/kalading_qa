class AddNamePinyinToAutos < ActiveRecord::Migration
  def change
    add_column :auto_brands, :name_pinyin, :string
    add_index :auto_brands, :name_pinyin
  end
end
