# frozen_string_literal: true

require 'quality/rake/task'

Quality::Rake::Task.new do |task|
  task.exclude_files = ['Gemfile.lock']
  # cane deprecated in favor of rubocop, reek rarely actionable
  task.skip_tools = %w[reek cane shellcheck]
  task.output_dir = 'metrics'
end

task quality: %i[pronto update_bundle_audit]
