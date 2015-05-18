class AddUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
