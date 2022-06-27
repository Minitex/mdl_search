server 'mtx-reflectqa-qat.oit.umn.edu', roles: [:job]
server 'mtx-reflectqa-qat2.oit.umn.edu', roles: [:web, :app, :db]

set :branch, ENV.fetch('BRANCH', 'develop')
