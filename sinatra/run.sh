#!/usr/bin/env bash
#
# Launch the app using rerun (reloads when files are modified)

#use -l 80 in production
bundle exec unicorn -l 4567

# Otherwise just 'bundle exec ruby app.rb'
