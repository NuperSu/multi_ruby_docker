# frozen_string_literal: true

require_relative "lib/multiruby/version"

Gem::Specification.new do |spec|
  spec.name = "multiruby"
  spec.version = Multiruby::VERSION
  spec.authors = ["NuperSu"]
  spec.email = ["93143246+NuperSu@users.noreply.github.com"]

  spec.summary       = "A Docker-based environment for managing multiple Ruby versions using RVM."
  spec.description   = "MultiRuby provides a comprehensive Docker setup based on Ubuntu 24.04, enabling developers to work with multiple Ruby versions (2.3 to 3.3) managed via RVM. It ensures compatibility and ease of use for running Ruby applications with a `Gemfile` across different Ruby environments."
  spec.homepage      = "https://github.com/NuperSu/multiruby-docker"
  spec.required_ruby_version = ">= 2.3.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/NuperSu/multiruby-docker"
  spec.metadata["changelog_uri"]     = "https://github.com/NuperSu/multiruby-docker/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0").reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "rvm", "~> 1.29"
  spec.add_dependency "bundler", "~> 2.3"

  spec.add_development_dependency "minitest", "~> 5.16"
  spec.add_development_dependency "rake", "~> 13.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
