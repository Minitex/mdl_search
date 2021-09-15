#!/bin/bash

# Build the local solr core
git clone https://github.com/UMNLibraries/mdl-solr-core.git;
(cd mdl-solr-core; ./rebuild.sh);

# Build, start the app
mkdir -p public/assets/thumbnails;
docker-compose build -- solr solr_test db redis webpacker;
docker-compose up -d solr solr_test db redis webpacker;
until docker exec mdl_search_db_1 mysql --user=mdl --password=mdl -e "select 1" >/dev/null
do
  echo "Waiting for MySQL to start..."
  sleep 1
done
bundle exec rake db:migrate db:test:prepare
yarn install
