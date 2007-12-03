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
task :test => 'ext/xray/libxray.so'

desc 'Generate documentation for XRay.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'XRay'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

file 'ext/xray/Makefile' => 'ext/xray/extconf.rb' do
  Dir.chdir('ext/xray') do
    ruby 'extconf.rb'
  end
end

file 'ext/xray/libxray.so' => 'ext/xray/Makefile' do
  Dir.chdir('ext/xray') do
    pid = fork { exec "make" }
    Process.waitpid pid
  end
  fail "Make failed (status #{m})" unless $?.exitstatus == 0
end

specification = Gem::Specification.new do |s|
  s.name = "XRay"
  s.summary = "Dump backtrace for all threads."
  s.version = "0.1"
  s.author = "Philippe Hanrigou"
	s.email = 'xray-developer@rubyforge.org'
  s.homepage = "http://xray.rubyforge.com"
  s.rubyforge_project = 'flipper'
  s.platform = Gem::Platform::RUBY
  s.files = ["ext/xray/xray.c", "ext/xray/extconf.rb"] + FileList['test/**/*.rb']
  s.require_path = "."
  # s.autorequire = "MenuBuilder"
  s.extensions = ["ext/xray/extconf.rb"]
  s.rdoc_options << '--title' << 'Flipper' << '--main' << 'README' << '--line-numbers'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
	s.test_file = "test/all_tests.rb"
end
  
Rake::GemPackageTask.new(specification) do |package|
	 package.need_zip = false
	 package.need_tar = false
end
