class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  # 退出登录后，跳转到的路径。
  # 默认是root_path，会因为没有登录而再次跳转到sign in path，多了一次跳转。
  # 而且admin退出登录后也跳转到root_path，这不合适。
  # 所以在这里重写为，跳转到对应scope的sign in path。
  def after_sign_out_path_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    session_path(scope)
  end
end
