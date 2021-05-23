# coding: ascii
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bigfiles/version'

Gem::Specification.new do |spec|
  spec.name          = 'bigfiles'
  spec.version       = BigFiles::VERSION
  spec.authors       = ["Vince Broz"]
  spec.email         = ['vince@broz.cc']
  spec.summary       = "Simple tool to find the largest source files in your project."
  spec.homepage      = 'https://github.com/apiology/bigfiles'
  spec.license       = 'MIT license'
  spec.required_ruby_version = '>= 2.6'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest-profile'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '>=3.4'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-lcov'
  spec.add_development_dependency 'undercover'
end
