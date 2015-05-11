class Answer < ActiveRecord::Base
  belongs_to :question

  validates_presence_of :question_id, :replier_id, :replier_type, :content
end
