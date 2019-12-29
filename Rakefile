# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'quality/rake/task'
require 'bundler/gem_tasks'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = '--format doc'
end

desc 'Run features'
RSpec::Core::RakeTask.new(:feature) do |task|
  task.pattern = 'feature/**/*_spec.rb'
  task.rspec_opts = '--format doc'
end

task :clear_metrics do |_t|
  ret =
    system('git checkout coverage/.last_run.json metrics/*_high_water_mark')
  raise unless ret
end

desc 'Default: Run specs and check quality.'
task test: %i[spec feature]
task localtest: %i[clear_metrics spec feature quality]
task default: [:localtest]
