class AutoModel < ExternalManagement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  attr_readonly *fields.keys

  belongs_to :auto_brand
  has_many :auto_submodels
end
