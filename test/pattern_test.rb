require File.join(File.dirname(__FILE__), 'test_helper')

class PatternTest < Test::Unit::TestCase
  describe 'Module' do
    should 'maps names to proper Pattern module' do
      assert_equal HMachine::Pattern::ValueClass, HMachine::Pattern.map(:value_class)
    end
    
    should 'raise an error if the pattern is not defined' do
      assert_raise RuntimeError do 
        HMachine::Pattern.map :foobar
      end
    end
  end
end