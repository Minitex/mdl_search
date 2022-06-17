set :domain, "swadm@mtx-reflection-prd.oit.umn.edu"

role :app, "swadm@mtx-reflection-prd.oit.umn.edu"
role :web, "swadm@mtx-reflection-prd.oit.umn.edu"
role :db, "swadm@mtx-reflection-prd.oit.umn.edu", primary: true

set :deploy_to, '/swadm/var/www/mtx-reflection-prd.oit.umn.edu'

set :branch, 'main'
