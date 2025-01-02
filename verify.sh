#!/bin/bash
RUBY_VERSIONS=(2.3.8 2.4.10 2.5.9 2.6.10 2.7.8 3.0.7 3.1.6 3.2.6 3.3.6)

for version in "${RUBY_VERSIONS[@]}"; do
  echo "Testing Ruby $version..."
  docker run --rm -e RUBY_V=$version -v $(pwd):/app multi_ruby rake test
done