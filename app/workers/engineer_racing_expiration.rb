class EngineerRacingExpiration
  include Sidekiq::Worker
  sidekiq_options queue: :"#{Rails.env}_default"

  def perform(question_id)
    question = Question.where(id: question_id).first
    return if question.nil?
    return if question.any_engineer_raced?

    ids = User.dispatchers.pluck(:internal_id)
    question.fall_back_on_specialist!(ids[rand(ids.size)])
  end
end
