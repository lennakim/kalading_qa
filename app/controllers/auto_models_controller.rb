class AutoModelsController < ApplicationController
  def index
    @container = AutoModel.where(auto_brand_internal_id: params[:auto_brand_id]).pluck(:name, :internal_id)

    respond_to do |format|
      format.html { render 'shared/options_for_select', layout: false }
    end
  end
end
