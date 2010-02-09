require File.join(File.dirname(__FILE__), 'test_helper')

class PropertyTest < Test::Unit::TestCase
  should 'have a name' do
    test = HMachine::Property.new(:fn)
    assert_equal :fn, test.name
  end
  
  should 'normalize names' do
    assert_equal :email, HMachine::Property.new("Email").name
  end
  
  should 'be a property of a microformat' do
    test = HMachine::Property.new(:fn, :base)
    assert_equal HMachine::POSH::Base, test.parent
  end
  
  should 'test to see if it is a property of a microformat' do
    test = HMachine::Property.new(:fn)
    assert !test.property_of?(:valueclass), "Property is the property of #{test.parent}"
    assert test.property_of?(:base)
    assert test.child_of?(:base)
  end
  
  should 'parse a document to find itself' do
    test = HMachine::Property.new(:fn)
    html = get_fixture('hcard/commercenet.html')
    doc = Nokogiri.parse(html)
    fn = doc.css('.fn').first.content
    assert_equal fn, test.parse(doc)
  end
  
  should 'have subproperties' do
    test = HMachine::Property.new(:fn)
    test.has_one :n
    assert test.properties.has_key?(:n), "Subproperties are #{test.properties.inspect}"
  end
  
  should 'belong to another property if this is a subproperty' do
    test = HMachine::Property.new(:fn)
    test.has_one :n
    assert_equal test, test.properties[:n].parent
  end
  
  should 'pass a block to further refine subproperties' do
    test = HMachine::Property.new(:fn)
    test.has_one :n do |n| 
      n.extract { 'foobar' }
    end
    assert_equal 'foobar', test.properties[:n].extract.call
  end
  
  should 'find subproperty by key' do
    test = HMachine::Property.new(:fn)
    test.has_one :n
    assert_equal test.properties[:n], test[:n]
  end
end