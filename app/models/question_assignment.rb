class QuestionAssignment < ActiveRecord::Base
  include AASM

  belongs_to :question
  belongs_to :user, foreign_key: 'user_internal_id', primary_key: 'internal_id'

  validates_presence_of :question_id, :user_internal_id, :user_role, :state

  aasm column: 'state' do
    state :processing, initial: true
    state :finished

    event :process do
      transitions from: :processing, to: :finished
    end
  end
end
