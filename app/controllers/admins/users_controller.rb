class Admins::UsersController < Admins::ApplicationController
  def sign_in_as
    user = User.find(params[:id])
    sign_in(:user, user, bypass: true)
    redirect_to root_path
  end

  def be_able_to_sign_in
    @users = User.be_able_to_sign_in.page(params[:page])
  end
end
