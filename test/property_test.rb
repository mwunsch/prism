require File.join(File.dirname(__FILE__), 'test_helper')

class PropertyTest < Test::Unit::TestCase
  should 'have a name' do
    test = HMachine::Property.new(:fn)
    assert test.name == :fn
  end
  
  should 'normalize names' do
    assert HMachine::Property.normalize("Email") == :email
  end
end