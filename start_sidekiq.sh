#!/bin/bash

###
# This is a fuzzy replica of the file we use to start
# Sidekiq in deployed environments.

# source env vars

queue="${1:-default -q critical,2 -q archive_generation,1}"
environment=${RAILS_ENV:-development}
bundle exec sidekiq -e $environment -q $queue
