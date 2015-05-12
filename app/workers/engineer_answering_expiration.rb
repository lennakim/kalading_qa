class EngineerAnsweringExpiration
  include Sidekiq::Worker
  sidekiq_options queue: :"#{Rails.env}_default"

  def perform(question_assignment_id)
    assignment = QuestionAssignment.where(id: question_assignment_id).first
    return if assignment.nil?
    return if !assignment.may_expire?

    assignment.expire!
  end
end
