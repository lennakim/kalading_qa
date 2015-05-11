class QuestionsController < ApplicationController
  load_resource only: [:nullify, :to_dispatcher, :to_engineer]

  def index
    redirect_to dispatcher_questions_path and return if current_user.dispatcher?

    params[:state] ||= 'init'
    authorize! :"read_#{params[:state]}", Question

    @questions = Question.where(state: params[:state]).page(params[:page])
    render "#{params[:state]}_questions"
  end

  def dispatcher_questions
    authorize! :direct_answer, Question

    @questions = QuestionAssignment.where(user_internal_id: current_user.internal_id)
                                   .includes(:question).all.map(&:question)
  end

  def nullify
    authorize! :check, Question

    if @question.nullify!
      flash[:notice] = '标为无效问题成功'
    else
      flash[:error] = '标为无效问题失败'
    end
    redirect_to questions_path(state: 'init')
  end

  def to_dispatcher
    authorize! :check, Question

    ids = User.dispatchers.pluck(:internal_id)
    if @question.assign_to_dispatcher!(ids[rand(ids.size)])
      flash[:notice] = '分配给客服成功'
    else
      flash[:error] = '分配给客服失败'
    end
    redirect_to questions_path(state: 'init')
  end

  def to_engineer
    authorize! :check, Question

    # @question
  end

  # 示例，以后不需要了可以删掉
  def new
    @question = Question.new
  end

  # 示例，以后不需要了可以删掉
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to questions_path
    else
      render action: 'new'
    end
  end

  private

  def question_params
    params.require(:question).permit(images: [])
  end
end
