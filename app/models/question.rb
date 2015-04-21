class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :question_category
  belongs_to :auto_brand
  belongs_to :auto_model
  belongs_to :auto_submodel
  belongs_to :customer
end
