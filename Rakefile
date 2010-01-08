$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'hmachine'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "hmachine"
    gemspec.summary = "Ruby microformat parser"
    gemspec.description = "A Ruby microformat parser powered by Nokogiri"
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