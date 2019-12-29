# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  # this dir used by TravisCI
  add_filter '/vendor/bundle'
end
SimpleCov.refuse_coverage_drop
require 'bigfiles'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.order = 'random'
  config.alias_it_should_behave_like_to :has_behavior
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end
