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
  
  should 'have a set of patterns for extraction' do
    test = HMachine::Property.new(:fn)
    assert_respond_to test.patterns, :length
  end
  
  should 'add patterns to extract content' do
    test = HMachine::Property.new(:fn)
    test.extract_with :value_class, :abbr_design
    assert_equal test.patterns, [:value_class, :abbr_design]
  end
  
  should 'extract content from a node' do
    html = get_fixture('hcard/commercenet.html')
    fn = HMachine::Property.new(:fn)
    node = fn.find_in(Nokogiri::HTML.parse(html))[0]
    assert_equal "CommerceNet", fn.extract_from(node)
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
  
  should 'test to see if the property can be found in a node' do
    html = get_fixture('hcard/commercenet.html')
    fn = HMachine::Property.new(:fn)
    node = Nokogiri::HTML.parse(html)
    assert fn.found_in?(node), "The property #{fn.name.inspect} is not found"
  end
end