%w[保养 维修 发动机 保险 其他].each do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end
