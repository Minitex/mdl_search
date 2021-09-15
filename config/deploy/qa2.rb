set :domain, "swadm@mtx-reflectqa-qat2.oit.umn.edu"

role :app, "swadm@mtx-reflectqa-qat2.oit.umn.edu"
role :web, "swadm@mtx-reflectqa-qat2.oit.umn.edu"
role :db, "swadm@mtx-reflectqa-qat2.oit.umn.edu", primary: true

set :ssh_options, { forward_agent: true }

set :deploy_to, '/swadm/var/www/mtx-reflectqa-qat2.oit.umn.edu'
set :use_sudo, false

set :bundle_flags, '--deployment'

set :keep_releases, 2
set :passenger_restart_with_touch, true

set :branch, ENV.fetch('BRANCH', 'develop')
