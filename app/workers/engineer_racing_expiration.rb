class EngineerRacingExpiration
  include Sidekiq::Worker
  sidekiq_options queue: :"#{Rails.env}_default", retry: 2

  # 一段时间后没技师回答（抢到没回答也算没人回答），则问题给专家
  def perform(question_id)
    question = Question.where(id: question_id).first
    return if question.nil?
    return if !question.may_fall_back_on_specialist?
    return if question.anyone_answered?

    # 1. 先把问题设置为不能抢答
    question.update_attribute(:can_be_raced, false)

    # 2. 再把问题给专家
    ids = User.dispatchers.pluck(:internal_id)
    question.fall_back_on_specialist!(ids[rand(ids.size)])

    # 3. 然后再把抢到但没回答的设为expired
    # 以上3步顺序不能变。如果先进行第3步的话，问题会变成能够抢答的状态，
    # 在把问题给专家的过程中，技师可以来抢答问题。
    QuestionAssignment.where(state: 'processing', handler: 'engineer').each do |assign|
      assign.expire! if assign.may_expire?
    end
  end
end
