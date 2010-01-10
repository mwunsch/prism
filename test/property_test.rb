require File.join(File.dirname(__FILE__), 'test_helper')

class PropertyTest < Test::Unit::TestCase  
  should 'have a name' do
    test = HMachine::Property.new(:fn)
    assert_equal :fn, test.name
  end
  
  should 'normalize names' do
    assert_equal :email, HMachine::Property.normalize("Email")
  end
  
  should 'be a property of a microformat' do
    test = HMachine::Property.new(:fn, :hcard)
    assert_equal HMachine::Microformat::HCard, test.property_of
  end
  
  should 'test to see if it is a property of a microformat' do
    test = HMachine::Property.new(:fn)
    assert !test.property_of?(:hcard), "Property is the property of #{test.property_of}"
  end
  
  should 'have a default search method' do
    test = HMachine::Property.new(:fn)
    assert_respond_to test.search, :call
  end
  
  should 'be able to redefine search function' do
    test = HMachine::Property.new(:fn)
    test.search { test.name }
    assert_equal :fn, test.search.call
  end
  
  should 'be able to find itself in a node' do
    html = get_fixture('hcard/commercenet.html')
    fn = HMachine::Property.new(:fn)
    assert fn.find_in(Nokogiri::HTML.parse(html))[0]['class'].include?(fn.name.to_s), "Property #{fn.name.inspect} not found."
  end
end