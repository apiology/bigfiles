# frozen_string_literal: true

require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  # Exclude these files for bigfiles reasons.
  #
  # Gemfile.lock and is large and not really refactorable
  #
  # .rubocop.yml is pretty regular and a refactor would just make
  # things harder to find.
  task.exclude_files = ['Gemfile.lock', '.rubocop.yml']
  # cane deprecated in favor of rubocop, reek rarely actionable
  task.skip_tools = %w[reek cane shellcheck]
  task.output_dir = 'metrics'
end

task quality: %i[pronto update_bundle_audit]
