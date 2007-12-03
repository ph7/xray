require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/clean'

task :default => [ :build_extension, :'test:unit']

Rake::TestTask.new("test:unit") do |t|
  t.pattern = 'test/**/*_test.rb'
end
Rake::Task["test:unit"].comment = "run unit tests"

task :build_extension do
  sh "ext/xray/extconf.rb"
  sh "make -C ext/xray clean all"
end
