class QuestionAssignment < ActiveRecord::Base
  include AASM

  belongs_to :question
  belongs_to :user, foreign_key: 'user_internal_id', primary_key: 'internal_id'

  validates :question_id, uniqueness: { scope: :user_internal_id }, on: :create
  validates_presence_of :question_id, :user_internal_id, :handler, :state, :question_state

  before_validation :set_question_state, on: :create

  scope :current, -> (user_internal_id) { where(user_internal_id: user_internal_id, state: 'processing') }
  scope :available, -> (user_internal_id) { where(user_internal_id: user_internal_id, state: ['processing', 'answered']) }
  scope :answered, -> (user_internal_id) { where(user_internal_id: user_internal_id, state: 'answered') }

  aasm column: 'state' do
    state :processing, initial: true
    state :answered
    state :expired

    event :process do
      before do
        empty_expire_at
      end
      transitions from: [:processing, :answered], to: :answered
    end

    event :expire do
      after do
        decrease_race_count!
      end
      transitions from: :processing, to: :expired
    end
  end

  def empty_expire_at
    self.expire_at = nil
  end

  def decrease_race_count!
    question.decrease_race_count
    question.save!
  end

  def set_question_state
    self.question_state = question.state
  end
end
