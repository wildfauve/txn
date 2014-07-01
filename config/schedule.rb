# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# start cron jobs
# whenever --update-crontab fish-txn
# 
# Remove cron jobs
# whenever -c fish-txn
#
# Check status of Cron
# crontab -l


set :environment, 'development'
set :output, "/Users/wildfauve/apps/fish/txn/log/cron_log.log"
#
every 1.minute do
  runner "CustomerEvent.check_for_events" 
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever