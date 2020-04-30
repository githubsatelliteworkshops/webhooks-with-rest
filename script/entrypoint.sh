#!/bin/bash
set -e

cp /data/apps/changelogger/.bundle/config /usr/local/bundle/config

exec "$@"
