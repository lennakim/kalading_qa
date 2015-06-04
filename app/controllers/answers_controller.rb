class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]
  before_action :check_replier_type, only: [:new, :create]
  load_resource only: [:edit, :update, :adopt]

  def new
    @answer = @question.answers.build
    @adoptable = true
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
      @adoptable = true
      render action: 'new'
    end
  end

  def edit
    render layout: false
  end

  def update
    @answer.update_attributes(answer_update_params)

    respond_to do |format|
      format.js
    end
  end

  def adopt
    if @answer.adopt(current_user.internal_id, current_user.role_list.first)
      flash[:notice] = '采纳答案成功'
    else
      flash[:error] = @answer.errors.full_messages.presence || '采纳答案失败'
    end
    redirect_to new_question_answer_path(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def check_replier_type
    @by_specialist = params[:replier_source] == 'specialist'
  end

  def answer_params
    params.require(:answer).permit(:content, :replier_id, :replier_type)
  end

  def answer_update_params
    params.require(:answer).permit(:content)
  end
end
