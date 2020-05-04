#!/usr/bin/env pwsh

docker run --rm -it -e RAILS_ENV=development--name changelogger --mount type=bind,source="$(pwd)"/changelogger,target=/data/apps/changelogger changelogger:latest bundle exec rails c
