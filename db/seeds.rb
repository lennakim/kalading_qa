%w[dispatcher support_manager engineer specialist manager].each do |role|
  Role.find_or_create_by!(name: role)
end
