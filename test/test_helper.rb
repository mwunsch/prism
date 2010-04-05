begin
  # Try to require the preresolved locked set of gems.
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fall back on doing an unlocked resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'test/unit'
require 'contest'
require 'fakeweb'
# redgreen does not work in ruby 1.9.1
begin
  require 'redgreen'
rescue LoadError
end


begin
  require 'prism'
rescue LoadError
  lib_path = File.join(File.dirname(__FILE__), '..', 'lib')
  $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
  require 'prism'
end

def get_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}")).read
end

# http://microformats.org/wiki/test-fixture
def test_fixture(filename)
  html = get_fixture('test-fixture/' + filename)
  doc = Nokogiri::HTML.parse(html).css('#uf').first
end