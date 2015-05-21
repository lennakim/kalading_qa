namespace :qa do
  desc 'Update authentication token of management API'
  task update_token: :environment do
    if UserToken.update_token
      puts "Updating authentication token succeeded."
    else
      puts "Updating authentication token failed.".colorize(:red)
    end
  end
end
