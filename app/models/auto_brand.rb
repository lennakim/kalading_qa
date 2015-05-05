class AutoBrand < ActiveRecord::Base
  validates_presence_of :name, :internal_id

  has_many :auto_models, dependent: :destroy
end
