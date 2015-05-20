class AutoBrand < ActiveRecord::Base
  include Concerns::AutoSync
  attr_sync :name

  has_many :auto_models, dependent: :destroy, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'

  validates_presence_of :name, :internal_id
end
