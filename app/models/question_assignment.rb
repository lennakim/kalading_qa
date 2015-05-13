class QuestionAssignment < ActiveRecord::Base
  include AASM

  belongs_to :question
  belongs_to :user, foreign_key: 'user_internal_id', primary_key: 'internal_id'

  validates :question_id, uniqueness: { scope: :user_internal_id }
  validates_presence_of :question_id, :user_internal_id, :user_role, :state, :question_state

  before_validation :set_question_state, on: :create

  aasm column: 'state' do
    state :processing, initial: true
    state :answered
    state :expired

    event :process do
      before do
        empty_expire_at
      end
      transitions from: :processing, to: :answered
    end

    event :expire do
      after do
        decrement_question_count!
      end
      transitions from: :processing, to: :expired
    end
  end

  def empty_expire_at
    self.expire_at = nil
  end

  def decrement_question_count!
    question.decrement(:engineer_race_count).save!(validate: false)
  end

  def set_question_state
    self.question_state = question.state
  end
end
