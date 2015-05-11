%w[保养 维修 发动机 保险 其他].each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

# 创建总裁登录帐号
if !User.where(phone_num: '18655550002').exists?
  User.create!(
    phone_num: '18655550002',
    password: '1'*6,
    role: 'manager',
    name: '总裁',
    name_pinyin: 'zongcai',
    internal_id: 'internal_0002_0'
  )
end

# 创建客服登录帐号
if !User.where(phone_num: '18655550006').exists?
  User.create!(
    phone_num: '18655550006',
    password: '1'*6,
    role: 'dispatcher',
    name: '客服',
    name_pinyin: 'kefu',
    internal_id: 'internal_0006_0'
  )
end

# 创建客服主管登录帐号
if !User.where(phone_num: '18655550011').exists?
  User.create!(
    phone_num: '18655550011',
    password: '1'*6,
    role: 'dispatcher_manager',
    name: '客服主管',
    name_pinyin: 'kefuzhuguan',
    internal_id: 'internal_0011_0'
  )
end

# 创建客服列表
3.times do |i|
  i += 1
  phone_num = "18655550006+#{i}"
  if !User.where(phone_num: phone_num).exists?
    User.create!(
      phone_num: phone_num,
      role: 'dispatcher',
      name: "客服#{i}",
      internal_id: "internal_0006_#{i}"
    )
  end
end

# 创建技师列表
3.times do |i|
  i += 1
  phone_num = "18655550005+#{i}"
  if !User.where(phone_num: phone_num).exists?
    User.create!(
      phone_num: phone_num,
      role: 'engineer',
      name: "技师#{i}",
      internal_id: "internal_0005_#{i}"
    )
  end
end

# 创建专家列表
3.times do |i|
  i += 1
  phone_num = "18655550012+#{i}"
  if !User.where(phone_num: phone_num).exists?
    User.create!(
      phone_num: phone_num,
      role: 'expert',
      name: "专家#{i}",
      internal_id: "internal_0012_#{i}"
    )
  end
end
