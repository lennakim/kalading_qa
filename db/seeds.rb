%w[dispatcher support_manager engineer specialist manager].each do |role|
  Role.find_or_create_by!(name: role)
end

['用车保养', '故障维修', '车险交规', '美容外观', '新车 二手车', '其他'].each do |tag|
  ActsAsTaggableOn::Tag.find_or_create_by!(name: tag)
end


# 创建客服登录帐号
if !User.where(phone_num: '18655551001').exists?
  dispatcher = User.create!(
    phone_num: '18655551001',
    password: '1'*6,
    name: '客服',
    name_pinyin: 'kefu',
    internal_id: 'internal_1001'
  )
  dispatcher.assign_roles('dispatcher')
end

# 创建客服主管登录帐号
if !User.where(phone_num: '18655552001').exists?
  support_manager = User.create!(
    phone_num: '18655552001',
    password: '1'*6,
    name: '客服主管',
    name_pinyin: 'kefuzhuguan',
    internal_id: 'internal_2001'
  )
  support_manager.assign_roles('support_manager')
end

# 创建总裁登录帐号
if !User.where(phone_num: '18655555001').exists?
  manager = User.create!(
    phone_num: '18655555001',
    password: '1'*6,
    name: '总裁',
    name_pinyin: 'zongcai',
    internal_id: 'internal_5001'
  )
  manager.assign_roles('manager')
end
