class QuestionBasesController < ApplicationController
  def index
    @question_bases = QuestionBase.page(params[:page])
  end

  def new
    answer = Answer.find(params[:answer_id])
    @question_base = answer.to_question_base
  end

  def create
    @question_base = QuestionBase.new(question_base_params)
    if @question_base.save
      flash[:notice] = '录入知识库成功'
      redirect_to question_bases_path
    else
      render action: 'new'
    end
  end

  private

  def question_base_params
    params.require(:question_base).permit(
      :auto_brand_internal_id,
      :auto_model_internal_id,
      :auto_submodel_internal_id,
      :question_content,
      :answer_content,
      question_images: []
    )
  end
end
