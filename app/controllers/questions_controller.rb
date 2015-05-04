class QuestionsController < ApplicationController
  def index
    params[:state] ||= 'new'

    @questions = Question.where(state: params[:state]).page(params[:page]).per(20)
    render "#{params[:state]}_questions"
  end
end
