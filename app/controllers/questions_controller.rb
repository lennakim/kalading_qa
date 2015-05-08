class QuestionsController < ApplicationController
  def index
    params[:state] ||= 'new'

    @questions = Question.where(state: params[:state]).page(params[:page])
    render "#{params[:state]}_questions"
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
