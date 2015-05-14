class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :replier, class_name: 'User', primary_key: 'internal_id'

  validates_presence_of :question_id, :replier_id, :replier_type, :content

  def adopt
    self.adopted_at = Time.current
    question.adopt

    assignment = question.question_assignments.answered(replier_id).first
    assignment.adopt

    transaction do
      self.save!
      question.save!
      assignment.save!
    end
    true
  rescue ActiveRecord::RecordInvalid
    log.warn("Adopting answer failed. Answer id: #{id}")
    false
  end

  def to_question_base
    QuestionBase.new(
      auto_brand_internal_id: question.auto_brand_internal_id,
      auto_model_internal_id: question.auto_model_internal_id,
      auto_submodel_internal_id: question.auto_submodel_internal_id,
      question_content: question.content,
      answer_content: content
    )
  end
end
