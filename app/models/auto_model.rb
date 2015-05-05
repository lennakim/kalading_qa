class AutoModel < ActiveRecord::Base
  validates_presence_of :name, :internal_id, :auto_brand_id

  belongs_to :auto_brand
  has_many :auto_submodels, dependent: :destroy
end
