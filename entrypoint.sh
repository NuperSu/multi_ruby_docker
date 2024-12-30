#!/usr/bin/env bash
set -e

source /usr/local/rvm/scripts/rvm

# use the Ruby version specified in the RUBY_VERSION environment variable or .ruby-version file
if [ -n "$RUBY_VERSION" ]; then
  echo "Using Ruby version: $RUBY_VERSION"
  rvm use "$RUBY_VERSION" --default
elif [ -f .ruby-version ]; then
  RUBY_VERSION=$(cat .ruby-version)
  echo "Using Ruby version: $RUBY_VERSION"
  rvm use "$RUBY_VERSION" --default
else
  echo "No Ruby version specified"
  exit 1
fi

# install/update dependencies
bundle install

# run the command that was passed through the docker run command
exec "$@"
