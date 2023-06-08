#!/bin/bash
set -e

cp /data/apps/changelogger/.bundle/config /usr/local/bundle/config

# needed to fix issue with nokogiri: `Could not find nokogiri-1.10.9 in any of the sources`
# this probably isn't the best thing to do from an entrypoint, but it works for now
bundle install --path vendor/bundle

exec "$@"
