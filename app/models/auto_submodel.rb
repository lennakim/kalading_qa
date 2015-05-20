class AutoSubmodel < ActiveRecord::Base
  include Concerns::AutoSync
  attr_sync :name, :full_name, :auto_brand_internal_id, :auto_model_internal_id

  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'

  validates_presence_of :name, :full_name, :internal_id, :auto_brand_internal_id, :auto_model_internal_id
end
