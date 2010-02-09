require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PoshTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html)
  end
  
  describe 'Inheritance' do
    setup do
      @test_class = Class.new(HMachine::POSH::Base)
      property = 'vcard'
      @test_class.search { |doc| doc.css(".#{property}") }
      @test_class.validate { |node| node['class'] && node['class'].split(' ').include?(property) }
    end
    
    should 'parse itself out of a document' do
      assert_instance_of @test_class, @test_class.parse(@doc)
    end
    
    should "add a property to its group of properties" do
      property = @test_class.add_property(:fn)
      assert_equal HMachine::Property, property.class
      assert_equal property, @test_class.properties[:fn]
    end
    
    should 'further refine a property with a block' do
      property = @test_class.add_property(:fn, lambda{|p| p.subproperties :n } )
      assert_equal property[:n], @test_class.properties[:fn][:n]
    end
    
    should 'find a property' do
      property = @test_class.add_property(:fn)
      assert_equal property, @test_class[:fn]
    end
    
    should 'remove nested nodes from a node' do
      nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
      parsed = @test_class.find_in(Nokogiri::HTML.parse(nested)).first
      assert_equal "Mark Wunsch and", @test_class.remove_nested(parsed).content.strip
    end
    
    should 'have one property' do
      property = @test_class.has_one!(:fn)
      assert_equal 1, @test_class.instance_variable_get(:@has_one).length
    end
    
    should 'has many properties' do
      property = @test_class.has_many!(:tel)
      assert_equal property, @test_class.instance_variable_get(:@has_many).first
    end
    
    should 'have one property and define an instance method' do
      property = @test_class.has_one :fn
      assert_equal property.first, @test_class.instance_variable_get(:@has_one).first
      assert_respond_to @test_class.parse(@doc), :fn
      assert_equal property.first.parse_first(@doc), @test_class.parse(@doc).fn
    end
    
    should 'have many of a type of properties and define an instance method' do
      property = @test_class.has_many :tel
      assert_respond_to @test_class.parse(@doc), :tel
    end
  end
  
  describe 'Instance' do
    setup do
      @klass = Class.new(HMachine::POSH::Base)
      property = 'vcard'
      @klass.search { |doc| doc.css(".#{property}") }
      @klass.validate { |node| node['class'] && node['class'].split(' ').include?(property) }
      @node = @klass.find_in(@doc).first
    end
    
    should 'have a node' do
      assert_equal @node, @klass.new(@node).node
    end
    
    should 'have its own set of properties' do
      fn = @klass.has_one :fn
      @klass.has_many :foobar
      vcard = @klass.new(@node)
      assert vcard.properties.has_key?(:fn)
      assert !vcard.properties.has_key?(:foobar)
      assert_equal fn.first, vcard.properties[:fn]
    end
    
    should 'lookup a property value' do
      fn = @klass.has_one :fn
      vcard = @klass.new(@node)
      assert_equal vcard.to_h[:fn], vcard[:fn]
      assert_equal fn.first.parse_first(@node), vcard[:fn]
    end
    
    should 'convert to a hash' do
      fn = @klass.has_one :fn
      tel = @klass.has_many :tel
      @klass.has_many :foobar
      vcard = @klass.new(@node)
      assert vcard.to_h.has_key?(:fn)
      assert vcard.to_h.has_key?(:tel)
      assert !vcard.to_h.has_key?(:foobar)
    end
    
    should 'not search for properties in nested microformats' do
      nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
      doc = Nokogiri::HTML.parse(nested)
      @klass.has_many :fn
      vcard = @klass.parse_first(doc)
      assert vcard.instance_variable_get(:@first_node) != vcard.node
      assert_equal "Mark Wunsch", vcard.fn
    end
    
    should 'have a DSL for defining properties' do
      @klass.has_one :fn
      @klass.has_many :tel
      @klass.has_many! :foobar
      vcard = @klass.new(@node)
      assert_respond_to vcard, :fn
      assert_respond_to vcard, :tel
      assert !vcard.respond_to?(:foobar)
    end
    
  end
end