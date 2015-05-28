class QuestionsController < ApplicationController
  load_resource only: [:nullify, :to_dispatcher, :to_engineer]

  def index
    # 客服没有权限访问root_path，自动跳转到“客服处理问题”页面
    if request.path == root_path && !can?(:read_init, Question)
      redirect_to dispatcher_questions_path and return
    end

    params[:state] ||= 'init'
    authorize! :"read_#{params[:state]}", Question

    @questions = Question.where(state: params[:state]).page(params[:page])
    render "#{params[:state]}_questions"
  end

  def dispatcher_questions
    authorize! :direct_answer, Question

    @questions = QuestionAssignment.current(current_user.internal_id)
                                   .where(question_state: 'direct_answer')
                                   .includes(:question).all.map(&:question)
  end

  def specialist_questions
    authorize! :fallback_answer, Question

    @questions = QuestionAssignment.current(current_user.internal_id)
                                   .where(question_state: 'fallback')
                                   .includes(:question).all.map(&:question)
  end

  def my_processed_questions
    authorize! :read, :my_processed_questions

    @question_assignments = QuestionAssignment.answered(current_user.internal_id)
                                              .order(updated_at: :desc)
                                              .includes(:question)
                                              .page(params[:page])
  end

  def show
    @question = Question.find(params[:id])
    @editable = false
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

    if @question.assign_to_engineer!
      flash[:notice] = '群发给技师成功'
    else
      flash[:error] = '群发给技师失败'
    end
    redirect_to questions_path(state: 'init')
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

  # 示例调用的，以后不需要了可以删掉
  def question_params
    params.require(:question).permit({images: []}, :auto_submodel_internal_id, :customer_id, :content)
  end
end
