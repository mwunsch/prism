require File.join(File.dirname(__FILE__), 'test_helper')

class PoshBaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html)
    
    @klass = Class.new.send(:extend, HMachine::POSH)
    property = 'vcard'
    @klass.search { |doc| doc.css(".#{property}") }
    @klass.validate { |node| node['class'] && node['class'].split(' ').include?(property) }
  end
  
  should "add a property to its group of properties" do
    property = @klass.add_property(:fn)
    assert_equal HMachine::Property, property.class
    assert_equal property, @klass.properties[:fn]
  end
  
  should 'further refine a property with a block' do
    property = @klass.add_property(:fn) do |p|
      p.add_property(:n)
    end
    assert_equal property[:n], @klass.properties[:fn][:n]
  end
  
  should 'find a property' do
    property = @klass.add_property(:fn)
    assert_equal property, @klass[:fn]
  end
  
  should 'remove nested nodes from a node' do
    nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
    parsed = @klass.find_in(Nokogiri::HTML.parse(nested)).first
    assert_equal "Mark Wunsch and", @klass.remove_nested(parsed).content.strip
  end
  
  should 'have one property' do
    property = @klass.has_one!(:fn)
    assert_equal 1, @klass.instance_variable_get(:@has_one).length
  end
  
  should 'has many properties' do
    property = @klass.has_many!(:tel)
    assert_equal property, @klass.instance_variable_get(:@has_many).first
  end
  
  should 'parse by properties' do
    property = @klass.has_one :fn
    assert_equal property.first, @klass.instance_variable_get(:@has_one).first
    assert_equal 'CommerceNet', @klass.parse(@doc)[:fn]
  end
end