%w[dispatcher support_manager engineer specialist manager].each do |role|
  Role.find_or_create_by!(name: role)
end

['用车保养', '故障维修', '车险交规', '美容外观', '新车 二手车', '其他'].each do |tag|
  ActsAsTaggableOn::Tag.find_or_create_by!(name: tag)
end
