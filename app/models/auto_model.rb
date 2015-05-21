class AutoModel < ActiveRecord::Base
  include Concerns::AutoSync
  attr_sync :name, :auto_brand_internal_id

  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  has_many :auto_submodels, dependent: :destroy, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'

  validates_presence_of :name, :internal_id, :auto_brand_internal_id
end
