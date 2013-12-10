# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 1.minute do
  rake 'exchanges:tick'
end

# Learn more: http://github.com/javan/whenever
