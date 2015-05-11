class AutoSubmodel < ActiveRecord::Base
  belongs_to :auto_model

  validates_presence_of :name, :full_name, :internal_id, :auto_model_id
end
