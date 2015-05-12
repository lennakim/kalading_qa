module QuestionsHelper
  def truncate_question_content(content)
    truncate(content, length: 20)
  end
end
