require File.join(File.dirname(__FILE__), 'test_helper')

class MicroformatTest < Test::Unit::TestCase  
  should 'map a symbol to a design pattern' do
    assert HMachine::Microformat::HCard, HMachine::Microformat.map(:hcard)
    assert HMachine::Microformat::RelTag, HMachine.map(:reltag)
  end
  
  should 'find all microformats in a document' do
    huffduff = HMachine::Microformat.find_all get_fixture('huffduffer.html')
    assert_equal 45, huffduff.count
  end
  
  should 'find specific microformats in a document' do
    huffduff = HMachine::Microformat.find get_fixture('huffduffer.html'), :hcard
    assert_equal 'mawunsch', huffduff.first.fn
    assert_equal 10, huffduff.count
  end

end