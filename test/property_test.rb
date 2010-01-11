require File.join(File.dirname(__FILE__), 'test_helper')

class PropertyTest < Test::Unit::TestCase
  should 'include the HMachine general parser' do
    assert HMachine::Property.include?(HMachine), "Property includes #{HMachine::Property.ancestors.inspect}"
  end
  
  should 'have a name' do
    test = HMachine::Property.new(:fn)
    assert_equal :fn, test.name
  end
  
  should 'normalize names' do
    assert_equal :email, HMachine::Property.new("Email").name
  end

  should 'be a property of a microformat' do
    test = HMachine::Property.new(:fn, :hcard)
    assert_equal HMachine::Microformat::HCard, test.property_of
  end
  
  should 'test to see if it is a property of a microformat' do
    test = HMachine::Property.new(:fn)
    assert !test.property_of?(:hcard), "Property is the property of #{test.property_of}"
  end
  
  should 'parse a document to find itself' do
    test = HMachine::Property.new(:fn)
    html = get_fixture('hcard/commercenet.html')
    doc = Nokogiri.parse(html)
    fn = doc.css('.fn').first.content
    assert_equal fn, test.parse(doc)
  end
end