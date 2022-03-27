require 'rake/testtask'

task default: :main

task :main do
  ruby 'lib/main.rb'
end

Rake::TestTask.new do |task|
  task.libs << %w[lib test]
  task.pattern = 'test/*_test.rb'
end
