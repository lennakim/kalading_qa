class QuestionAssignment < ActiveRecord::Base
  include AASM

  belongs_to :question
  belongs_to :user, foreign_key: 'user_internal_id', primary_key: 'internal_id'

  validates :question_id, uniqueness: { scope: :user_internal_id }
  validates_presence_of :question_id, :user_internal_id, :user_role, :state

  # after_create :update_question_count

  aasm column: 'state' do
    state :processing, initial: true
    state :finished

    event :process do
      transitions from: :processing, to: :finished
    end
  end

  # def update_question_count
    # question.increment(:engineer_race_count) if user_role == 'engineer'
  # end
end
