class AutoSubmodel < ExternalManagement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  attr_readonly *fields.keys

  belongs_to :auto_model
end
