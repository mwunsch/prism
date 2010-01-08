require 'test/unit'
require File.join(File.dirname(__FILE__), "../vendor/gems/environment")

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') unless $LOAD_PATH.include?(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'hmachine'
