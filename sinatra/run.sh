#!/usr/bin/env bash
#
# Launch the app using rerun (reloads when files are modified)

bundle exec unicorn -l 4567

# Otherwise just 'bundle exec ruby app.rb'
