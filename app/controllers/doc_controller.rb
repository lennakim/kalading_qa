class DocController < ApplicationController
  skip_before_action :authenticate_user!
  layout "api"

  def v2
  end
end
