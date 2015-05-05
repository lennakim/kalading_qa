class AutoSubmodel < ActiveRecord::Base
  validates_presence_of :name, :full_name, :internal_id, :auto_model_id

  belongs_to :auto_model
end
