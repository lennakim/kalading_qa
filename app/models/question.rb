class Question < ActiveRecord::Base
  include AASM

  ENGINEER_RACING_DURATION = 1.hour
  ENGINEER_ANSWERING_DURATION = 20.minutes
  MAX_RACING_COUNT = 8

  serialize :images, JSON
  mount_uploaders :images, ImageUploader

  has_many :answers, dependent: :destroy
  has_many :question_assignments, dependent: :destroy
  has_and_belongs_to_many :tags
  belongs_to :auto_brand, foreign_key: 'auto_brand_internal_id', primary_key: 'internal_id'
  belongs_to :auto_model, foreign_key: 'auto_model_internal_id', primary_key: 'internal_id'
  belongs_to :auto_submodel, foreign_key: 'auto_submodel_internal_id', primary_key: 'internal_id'
  belongs_to :customer

  validates :engineer_race_count, numericality: { only_integer: true,
                                                  allow_nil: true,
                                                  greater_than_or_equal_to: 0,
                                                  less_than_or_equal_to: MAX_RACING_COUNT }
  validates_presence_of :auto_submodel_internal_id, :customer_id, :content, :state

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
      after do |dispatcher_id|
        create_dispatcher_assignment!(dispatcher_id)
      end
      transitions from: :init, to: :direct_answer
    end

    event :assign_to_engineer, after_commit: :add_engineer_question_expiration_job do
      before do
        set_expire_at_for_engineer
      end
      transitions from: :init, to: :race
    end

    event :fall_back_on_expert do
      transitions from: :race, to: :fallback
    end

    event :answer do
      before do
        empty_expire_at
      end
      transitions from: [:direct_answer, :race, :fallback], to: :answered
    end

    event :adopt do
      transitions from: :answered, to: :adopted
    end
  end

  def create_dispatcher_assignment!(dispatcher_id)
    question_assignments.create!(
      user_internal_id: dispatcher_id,
      user_role: 'dispatcher'
    )
  end

  def set_expire_at_for_engineer
    self.expire_at = Time.current.since(ENGINEER_RACING_DURATION)
  end

  def add_engineer_question_expiration_job
    EngineerRacingExpiration.perform_in(ENGINEER_RACING_DURATION, id)
  end

  def any_engineer_raced?
    engineer_race_count > 0
  end

  def can_be_raced?
    engineer_race_count <= MAX_RACING_COUNT
  end

  def race_by_engineer(engineer_id)
    if !can_be_raced?
      errors.add(:base, '已被其他技师抢到，您不能再抢答此题')
      return false
    end

    assignment = question_assignments.build(
      user_internal_id: engineer_id,
      user_role: 'engineer',
      expire_at: Time.current.since(ENGINEER_ANSWERING_DURATION)
    )
    transaction do
      assignment.save!
      increment(:engineer_race_count).save!(validate: false)
    end

    EngineerAnsweringExpiration.perform_in(ENGINEER_ANSWERING_DURATION, assignment.id)

    true
  rescue ActiveRecord::RecordInvalid
    logger.warn("Engineer race question failed: #{assignment.errors.full_messages.join(', ')}. question id: #{id}, engineer internal id: #{engineer_id}")
    false
  end

  def empty_expire_at
    self.expire_at = nil if race?
  end
end
