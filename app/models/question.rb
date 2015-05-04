class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_and_belongs_to_many :tags
  belongs_to :auto_brand
  belongs_to :auto_model
  belongs_to :auto_submodel
  belongs_to :customer
end
