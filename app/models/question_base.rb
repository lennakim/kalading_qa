# 问题库暂时不用question_bases表
class QuestionBase < ActiveRecord::Base
  serialize :question_images, JSON
  mount_uploaders :question_images, ImageUploader

  acts_as_taggable

  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'
  belongs_to :auto_submodel, foreign_key: 'auto_submodel_internal_id', primary_key: 'internal_id'

  validates_presence_of :auto_submodel_internal_id, :question_content, :answer_content
end
