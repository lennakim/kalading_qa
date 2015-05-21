class ReplierSummary < ActiveRecord::Base
  validates_numericality_of :answers_count, :adoptions_count, { only_integer: true, greater_than_or_equal_to: 0 }
  validates_numericality_of :bonus, { greater_than_or_equal_to: 0 }
  validates_presence_of :replier_id, :month

  def self.get_summary(replier_id, time)
    find_or_initialize_by(replier_id: replier_id, month: time.at_beginning_of_month)
  end

  def after_answer!
    increment(:answers_count).save!
  end

  def after_adopt!
    increment(:adoptions_count).save!
  end
end
