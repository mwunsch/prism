begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'hmachine'
require 'rake'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
   t.libs << "test"
   t.pattern = 'test/**/*_test.rb'
   t.verbose = false
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "hmachine"
    gemspec.summary = "Ruby microformat parser and HTML toolkit"
    gemspec.description = "A Ruby microformat parser and HTML toolkit powered by Nokogiri"
    gemspec.version = HMachine::VERSION
    gemspec.homepage = "http://github.com/mwunsch/hmachine"
    gemspec.authors = ["Mark Wunsch"]
    gemspec.email = ["mark@markwunsch.com"]
    gemspec.add_dependency 'nokogiri'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'hMachine'
  rdoc.main     = 'README.md'
  rdoc.rdoc_files.include('README.*', 'lib/**/*.rb', 'LICENSE')
  rdoc.options  << '--inline-source'
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r hmachine"
end