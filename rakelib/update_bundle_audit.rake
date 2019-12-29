# frozen_string_literal: true

task :update_bundle_audit do
  sh 'bundle-audit update'
end
