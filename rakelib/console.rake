# frozen_string_literal: true

desc 'Load up bigfiles in pry'
task :console do |_t|
  exec 'pry -I lib -r bigfiles'
end
