require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'

task :default => :'test:unit'

Rake::TestTask.new("test:unit") do |t|
  t.pattern = 'test/**/*_test.rb'
end
Rake::Task["test:unit"].comment = "run unit tests"
