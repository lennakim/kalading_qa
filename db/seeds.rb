%w[保养 维修 发动机 保险 其他].each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

if !User.where(phone_num: '18655550006').exists?
  User.create!(
    phone_num: '18655550006',
    password: '1'*6,
    role: 'dispatcher',
    name: '客服',
    name_pinyin: 'kefu'
  )
end
