require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rubygems'

CLEAN.include '**/*.o'
CLEAN.include '**/*.so'
CLEAN.include '**/*.bundle'
CLOBBER.include '**/*.log'
CLOBBER.include '**/Makefile'
CLOBBER.include '**/extconf.h'

desc 'Default: run unit tests.'
task :default => :test


desc 'Test XRay.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for XRay.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'XRay'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

specification = Gem::Specification.new do |s|
  s.name = "xray"
  s.summary = "Dump backtrace for all threads."
  s.version = "1.1"
  s.author = "Philippe Hanrigou"
	s.email = 'xray-developer@rubyforge.org'
  s.homepage = "http://xray.rubyforge.com"
  s.rubyforge_project = 'xray'
  s.platform = Gem::Platform::RUBY
  s.executables = FileList['bin/**/*'].collect {|path| path.sub /bin\//, ""}
  s.files = FileList['lib/**/*.rb'] + FileList['test/**/*.rb'] + FileList['examples/**/*'] +
            FileList['**/*.diff'] + [ "rails/init.rb"]
            [ 'gdb_macros', 'Rakefile' ]
  s.require_path = "lib"
  s.extensions = []
  s.rdoc_options << '--title' << 'XRay' << '--main' << 'README' << '--line-numbers'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
	s.test_file = "test/all_tests.rb"
end
  
Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = false
	 package.need_tar = false
end

desc "Publish RDoc on Rubyforge website"
task :publish_rdoc => :rdoc do
  sh "scp -i ~/.ssh/id_dsa -r rdoc/* #{ENV['USER']}@rubyforge.org:/var/www/gforge-projects/xray"
end
