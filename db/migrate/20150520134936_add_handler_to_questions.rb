class AddHandlerToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :handler, :string
  end
end
