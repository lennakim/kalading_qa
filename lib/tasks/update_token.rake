require 'tasks/rake_output'

namespace :qa do
  desc 'Update authentication token of management API'
  task update_token: :environment do
    if UserToken.update_token
      RakeOutput.succeed('Updating authentication token')
    else
      RakeOutput.fail('Updating authentication token')
    end
  end
end
