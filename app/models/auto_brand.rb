class AutoBrand < ActiveRecord::Base
  has_many :auto_models, dependent: :destroy

  validates_presence_of :name, :internal_id
end
