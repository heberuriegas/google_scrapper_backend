#!/bin/sh
set -e

bundle install

bundle exec rails db:migrate
bundle exec rails db:seed

exec "$@"