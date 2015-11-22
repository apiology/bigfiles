# ; -*-Ruby-*-
# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.join(File.dirname(__FILE__), 'lib')
require 'bigfiles/version'

Gem::Specification.new do |s|
  s.name = 'bigfiles'
  s.version = BigFiles::VERSION

  s.authors = ['Vince Broz']
  s.description = 'bigfiles finds the largest source files in your project ' \
                  'and reports on them'
  s.email = ['vince@broz.cc']
  s.executables = ['bigfiles']
  # s.extra_rdoc_files = ["CHANGELOG", "License.txt"]
  s.license = 'MIT'
  s.files = Dir['CODE_OF_CONDUCT.md', 'License.txt', 'README.md',
                '{lib}/bigfiles.rb',
                '{lib}/bigfiles/**/*.rb',
                'bigfiles.gemspec']
  # s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/apiology/bigfiles'
  # s.rubyforge_project = %q{bigfiles}
  s.rubygems_version = '1.3.6'
  s.summary = 'Finds largest source files in a project'

  s.add_dependency('source_finder', ['>=2'])
  s.add_development_dependency('bundler')
  s.add_development_dependency('rake')
  s.add_development_dependency('quality')
  s.add_development_dependency('rspec')
  s.add_development_dependency('simplecov')
end
