class QuestionBase < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'
  belongs_to :auto_submodel, foreign_key: 'auto_submodel_internal_id', primary_key: 'internal_id'

  validates_presence_of :auto_submodel_internal_id, :question_content, :answer_content
end
