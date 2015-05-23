class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]
  before_action :check_replier_type, only: [:new, :create]
  before_action :find_answer, only: [:adopt]

  def new
    @answer = @question.answers.build
    @editable = true
  end

  def create
    answer_attrs = answer_params
    if @by_specialist
      assignee_id = current_user.internal_id
    else
      answer_attrs[:replier_id] = current_user.internal_id
    end

    @answer = @question.answer(answer_attrs, assignee_id)
    if @answer.errors.blank?
      flash[:notice] = '添加答案成功'
      redirect_to my_processed_questions_path
    else
      @editable = true
      render action: 'new'
    end
  end

  def adopt
    if @answer.adopt
      flash[:notice] = '采纳答案成功'
    else
      flash[:error] = '采纳答案失败'
    end
    redirect_to new_question_answer_path(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def check_replier_type
    @by_specialist = params[:replier_source] == 'specialist'
  end

  def answer_params
    params.require(:answer).permit(:content, :replier_id, :replier_type)
  end
end
