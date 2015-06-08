class QuestionsController < ApplicationController
  load_resource only: [:nullify, :to_dispatcher, :to_engineer, :update,
                       :edit_content, :edit_auto_submodel, :edit_tags,
                       :edit_images, :update_images
                      ]

  def search
    params[:type] ||= 'collected'

    criteria =
      case params[:type]
      when 'questions'
        Question.where(state: %w[init direct_answer race fallback answered adopted])
      when 'collected'
        Question.where(state: 'collected')
      end

    if criteria
      criteria = criteria.where('content LIKE ?', "%#{params[:q]}%") if params[:q].present?
      @questions = criteria.page(params[:page])
    end
  end

  def index
    # 客服没有权限访问root_path，自动跳转到“客服处理问题”页面
    if request.path == root_path && !can?(:read_init, Question)
      redirect_to dispatcher_questions_path and return
    end

    params[:state] ||= 'init'
    authorize! :"read_#{params[:state]}", Question

    @questions = Question.where(state: params[:state])
                         .includes(:auto_submodel)
                         .page(params[:page])

    if params[:state].in?(%[answered adopted collected useless])
      @questions = @questions.order(id: :desc)
    end

    render "#{params[:state]}_questions"
  end

  def dispatcher_questions
    authorize! :direct_answer, Question

    @questions = QuestionAssignment.current(current_user.internal_id)
                                   .where(question_state: 'direct_answer')
                                   .includes(question: [:auto_submodel]).all.map(&:question)
  end

  def specialist_questions
    authorize! :fallback_answer, Question

    @questions = QuestionAssignment.current(current_user.internal_id)
                                   .where(question_state: 'fallback')
                                   .includes(question: [:auto_submodel]).all.map(&:question)
  end

  def my_processed_questions
    authorize! :read, :my_processed_questions

    @question_assignments = QuestionAssignment.answered(current_user.internal_id)
                                              .order(updated_at: :desc)
                                              .includes(question: [:auto_submodel])
                                              .page(params[:page])
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

  def show
    @question = Question.includes(answers: [:replier]).find(params[:id])
  end

  def edit
    @question = Question.includes(answers: [:replier]).find(params[:id])
  end

  def update
    @question.update_attributes(question_update_params)

    respond_to do |format|
      format.js
    end
  end

  def edit_content
    render layout: false
  end

  def edit_auto_submodel
    render layout: false
  end

  def edit_tags
    render layout: false
  end

  def edit_images
    render layout: false
  end

  def update_images
    case @question.remove_images(params[:images_identifiers])
    when nil
      flash[:notice] = '您没有修改问题图片'
    when true
      flash[:notice] = '修改问题图片成功'
    when false
      flash[:alert] = '修改问题图片失败'
    end

    respond_to do |format|
      format.js
    end
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

  def question_update_params
    params.require(:question).permit(:content, :auto_submodel_internal_id, {tag_ids: []})
  end
end
