class AutoModel < ActiveRecord::Base
  belongs_to :auto_brand
  has_many :auto_submodels, dependent: :destroy

  validates_presence_of :name, :internal_id, :auto_brand_id
end
