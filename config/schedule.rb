# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, {:error => "#{path}/log/cron_error.log", :standard => "#{path}/log/cron.log"}

every :day, at: '3:00 am', roles: [:cron] do
  rake 'qa:update_token'
end

every :day, at: '3:10 am', roles: [:cron] do
  rake 'qa:sync_dispatcher_data'
end

every :day, at: '3:20 am', roles: [:cron] do
  rake 'qa:sync_engineer_data'
end

every :day, at: '3:30 am', roles: [:cron] do
  rake 'qa:sync_specialist_data'
end

every :day, at: '3:40 am', roles: [:cron] do
  rake 'qa:sync_support_manager_data'
end

every :day, at: '3:50 am', roles: [:cron] do
  rake 'qa:sync_auto_data'
end
