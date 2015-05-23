class SessionsController < Devise::SessionsController
  layout 'session'

  def create
    if Settings.use_local_data_to_sign_in == true
      super and return
    end

    phone_num = params[:user][:phone_num]
    password = params[:user][:password]
    result = KaladingManagementApi.call('post', 'users/sign_in', {phone_num: phone_num, password: password})

    # API 登录成功
    if result['result'].downcase == 'ok'
      result['roles'] = result['role_str'].split(',')

      # 不是所有的后台帐号都能登录问答系统
      if !Role.valid_role?(result['roles'])
        self.resource = User.new(phone_num: phone_num)
        flash[:error] = '角色不正确，不能登录'
        render action: 'new' and return
      end

      update_user(phone_num, password, result)
      super
    else
      self.resource = User.new(phone_num: phone_num)
      flash[:error] = '帐号或密码错误'
      render action: 'new'
    end
  end

  def destroy
    clean_sign_in_as
    super
  end

  private

  def update_user(phone_num, password, result)
    user = User.find_or_initialize_by(internal_id: result['id'])
    # 用户在后台改过密码了，需要更新本地密码
    user.password = password if !user.valid_password?(password)

    user.attributes = {
      phone_num: phone_num,
      name: result['name'],
      name_pinyin: result['name_pinyin'],
      city_internal_id: result['city_id']
    }

    if user.save
      user.assign_roles(result['roles'])
    else
      Rails.logger.error("Updating user data failed while sign in. " \
                         "Errors: #{user.errors.full_messages.join(', ')}. " \
                         "API Response: #{result}.".colorize(:red))
    end
  end
end
