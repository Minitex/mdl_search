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
  rake 'blacklight:delete_old_searches[1]'
end

# Pick up new CDM records daily - Index All Items (from all collections)
every :friday, at: '11pm' do
  rake 'mdl_ingester:collections'
end

# Ensure content is commited daily (e.g. one-off indexn runs)
every 1.day, at: '12:00am' do
  rake 'solr:commit'
end

# Optimize index daily
every 1.day, at: '12:30am' do
  rake 'solr:optimize'
end

