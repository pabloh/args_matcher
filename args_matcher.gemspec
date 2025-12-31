# frozen_string_literal: true

require_relative "lib/args_matcher/version"

Gem::Specification.new do |spec|
  spec.name = "args_matcher"
  spec.version = ArgsMatcher::VERSION
  spec.authors = ["Pablo Herrero"]
  spec.email = ["pablodherrero@gmail.com"]

  spec.summary = "Pattern matching for method arguments in Ruby"
  spec.description = "A gem that provides pattern matching capabilities for method arguments in Ruby, allowing developers to match and destructure method arguments using Ruby's pattern matching syntax."
  spec.homepage = "https://github.com/pabloh/args_matcher"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pabloh/args_matcher"
  spec.metadata["changelog_uri"] = "https://github.com/pabloh/args_matcher/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 3.4'

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "binding_of_caller"

  spec.add_development_dependency "pry", ">= 0.16"
  spec.add_development_dependency "readline"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "repl_type_completor"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
