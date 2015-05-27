class Question < ActiveRecord::Base
  include AASM

  serialize :images, JSON
  mount_uploaders :images, ImageUploader

  acts_as_taggable

  has_many :answers, dependent: :destroy
  has_many :question_assignments, dependent: :destroy
  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'
  belongs_to :auto_submodel, foreign_key: 'auto_submodel_internal_id', primary_key: 'internal_id'
  belongs_to :customer

  validates :engineer_race_count, numericality: { only_integer: true,
                                                  allow_nil: true,
                                                  greater_than_or_equal_to: 0,
                                                  less_than_or_equal_to: Settings.question.race_limit }
  validates_presence_of :auto_submodel_internal_id, :customer_id, :content, :state

  delegate :full_name, to: :auto_submodel, prefix: true

  aasm column: 'state' do
    state :init, initial: true
    # 无效
    state :useless
    # 客服回答
    state :direct_answer
    # 技师抢答
    state :race
    # 专家回答
    state :fallback
    # 已解答
    state :answered
    # 已采纳
    state :adopted

    event :nullify do
      transitions from: :init, to: :useless
    end

    event :assign_to_dispatcher do
      before do
        self.handler = 'dispatcher'
      end
      after do |dispatcher_id|
        create_dispatcher_assignment!(dispatcher_id)
      end
      transitions from: :init, to: :direct_answer
    end

    event :assign_to_engineer, after_commit: :add_engineer_question_expiration_job do
      before do
        self.handler = 'engineer'
        self.can_be_raced = true
        set_expire_at_for_engineer
      end
      transitions from: :init, to: :race
    end

    event :fall_back_on_specialist do
      before do
        self.handler = 'dispatcher'
      end
      after do |fallback_id|
        create_fallback_assignment!(fallback_id)
      end
      transitions from: :race, to: :fallback
    end

    event :process do
      before do
        empty_expire_at
      end
      transitions from: [:direct_answer, :race, :fallback, :answered], to: :answered
    end

    event :adopt do
      transitions from: :answered, to: :adopted
    end
  end

  def has_images?
    images.present?
  end

  def persist_answers
    answers.select { |answer| answer.persisted? }
  end

  def create_dispatcher_assignment!(dispatcher_id)
    question_assignments.create!(
      user_internal_id: dispatcher_id,
      handler: 'dispatcher'
    )
  end

  def create_fallback_assignment!(fallback_id)
    question_assignments.create!(
      user_internal_id: fallback_id,
      handler: 'dispatcher'
    )
  end

  def set_expire_at_for_engineer
    self.expire_at = Time.current.since(Settings.question.engineer_race_duration)
  end

  def add_engineer_question_expiration_job
    EngineerRacingExpiration.perform_in(Settings.question.engineer_race_duration, id)
  end

  def anyone_answered?
    answers_count > 0
  end

  def any_engineer_raced?
    engineer_race_count > 0
  end

  def reach_race_limit?
    engineer_race_count >= Settings.question.race_limit
  end

  def check_for_race(engineer_id)
    if question_assignments.available(engineer_id).exists?
      errors.add(:base, '您已经抢答过此题')
    elsif reach_race_limit?
      errors.add(:base, '抢答人数已满')
    elsif fallback?
      errors.add(:base, '已交给专家来回答')
    elsif !can_be_raced?
      errors.add(:base, '您不能回答此题')
    end

    errors.blank?
  end

  def race_by_engineer(engineer_id)
    return false if !check_for_race(engineer_id)

    assignment = question_assignments.build(
      user_internal_id: engineer_id,
      handler: 'engineer',
      expire_at: Time.current.since(Settings.question.engineer_answering_duration)
    )
    increase_race_count

    transaction do
      assignment.save!
      self.save!
    end

    EngineerAnsweringExpiration.perform_in(Settings.question.engineer_answering_duration, assignment.id)

    true
  rescue ActiveRecord::RecordInvalid
    logger.warn("Racing question failed: #{assignment.errors.full_messages.join(', ')}. Question id: #{id}, engineer internal id: #{engineer_id}.")
    false
  end

  # answer_attrs: {
  #   replier_id: 'xxx',
  #   replier_type: 'engineer',
  #   content: 'bababa'
  # }
  #
  # 如果是回答自己的问题，比如技师回答问题。则assignee_id必须为空，replier_type可以为空，系统会自动判断
  # 如果是代别人回答问题，比如客服代专家回答问题。则assignee_id是客服的internal_id
  def answer(answer_attrs, assignee_id = nil)
    answer_obj = answers.build

    internal_id = assignee_id || answer_attrs[:replier_id]
    assignment = question_assignments.available(internal_id).first

    if assignment.nil?
      answer_obj.errors.add(:base, '您不能回答此题')
      return answer_obj
    end

    answer_attrs[:replier_type] ||= assignment.handler if assignee_id.nil?
    answer_obj.attributes = answer_attrs
    self.process if !self.adopted?
    assignment.process
    summary = ReplierSummary.get_summary(answer_attrs[:replier_id], Time.current)

    transaction do
      answer_obj.save!
      self.save!
      assignment.save!
      summary.after_answer!
    end
  rescue ActiveRecord::RecordInvalid
    error_message = [answer_obj, self, assignment].map { |obj| obj.errors.full_messages }.flatten.join(', ')
    logger.warn("Answering question failed: #{error_message}. Question id: #{id}, replier_id: #{replier_id}, replier_type: #{assignment.handler}.")
  ensure
    return answer_obj
  end

  def empty_expire_at
    self.expire_at = nil if race?
  end

  def increase_race_count
    increment(:engineer_race_count)
    set_can_be_raced
  end

  def decrease_race_count
    decrement(:engineer_race_count)
    set_can_be_raced
  end

  def set_can_be_raced
    if handler != 'engineer'
      self.can_be_raced = false
    else
      self.can_be_raced = !reach_race_limit?
    end
  end
end
