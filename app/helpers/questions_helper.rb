module QuestionsHelper
  def truncate_question_content(content)
    truncate(content, length: 40)
  end

  def display_answers_count(question)
    question.answers_count == 0 ? '还没有回答' : "#{question.answers_count}个回答"
  end
end
