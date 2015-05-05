class QuestionsController < ApplicationController
  def index
    params[:state] ||= 'new'

    @questions = Question.where(state: params[:state]).page(params[:page])
    render "#{params[:state]}_questions"
  end
end
