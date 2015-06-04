class AutoSubmodelsController < ApplicationController
  def index
    @container = AutoSubmodel.where(auto_model_internal_id: params[:auto_model_id]).pluck(:name, :internal_id)

    respond_to do |format|
      format.html { render 'shared/options_for_select', layout: false }
    end
  end
end
