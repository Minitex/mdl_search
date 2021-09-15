# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Prevent search sessions from bloating our DB
every 1.day, at: '12:15am' do
  rake "blacklight_maintenance:truncate_searches"
end

# Pick up new CDM records daily
every :friday, at: '11pm' do
  runner 'Index All Items (from all collections)'
  rake 'mdl_ingester:collections'
end

every 1.day, at: '12:00am' do
  runner 'Ensure content is commited daily (e.g. one-off indexn runs)'
  rake 'solr:commit'
end

every 1.day, at: '12:30am' do
  runner 'Optimize index daily'
  rake 'solr:optimize'
end

