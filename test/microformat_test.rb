require File.join(File.dirname(__FILE__), 'test_helper')

class MicroformatTest < Test::Unit::TestCase
  describe 'Mapper' do
    should 'map a symbol to a design pattern' do
      assert HMachine::Microformat::HCard, HMachine::Microformat.map(:hcard)
      assert HMachine::Microformat::RelTag, HMachine.map(:reltag)
    end
  end

end