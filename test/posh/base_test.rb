require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PoshBaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html, 'http://foobar.com/')
  end
  
  describe 'Inheritance' do
    setup do
      @test_class = Class.new(Prism::POSH::Base)
      @test_class.name :vcard
    end
    
    should "add a property to its group of properties" do
      property = @test_class.add_property(:fn)
      assert_equal property, @test_class.properties[:fn]
    end

    should 'further refine a property with a block' do
      property = @test_class.add_property(:fn) do
        add_property(:n)
      end
      assert_equal property[:n], @test_class.properties[:fn][:n]
    end
    
    should 'find a property' do
      property = @test_class.add_property(:fn)
      assert_equal property, @test_class[:fn]
    end
    
    should 'have one property' do
      property = @test_class.has_one!(:fn)
      assert_respond_to @test_class, :one
      assert_equal 1, @test_class.one.length
      assert @test_class.one.include?(property)
    end
    
    should 'have a set of requirements' do
      property = @test_class.has_one!(:fn)
      assert_respond_to @test_class, :requirements
      assert @test_class.requirements.empty?
      assert_respond_to property, :required!
      property.required!
      assert @test_class.requirements.include?(property)
    end

    should 'has many properties' do
      property = @test_class.has_many!(:tel)
      assert_respond_to @test_class, :many
      assert_equal 1, @test_class.many.length
      assert_equal property, @test_class.many.first
    end
    
    should 'parse by properties' do
      property = @test_class.has_one :fn
      assert_equal property.first, @test_class.one.first
      assert_equal 'CommerceNet', @test_class.parse_first(@doc)[:fn]
    end
    
    should 'parse itself out of a document' do
      @test_class.has_one :fn
      assert_instance_of @test_class, @test_class.parse(@doc).first
    end
    
    should 'have one property and define an instance method' do
      property = @test_class.has_one :fn
      assert_equal property.first, @test_class.instance_variable_get(:@has_one).first
      assert_respond_to @test_class.parse_first(@doc), :fn
      assert_equal property.first.parse_first(@doc), @test_class.parse_first(@doc).fn
    end
    
    should 'have many of a type of properties and define an instance method' do
      property = @test_class.has_many :tel
      assert_respond_to @test_class.parse_first(@doc), :tel
    end
    
    should 'subclasses retain properties' do
      @test_class.has_one :fn
      @test_class.has_many :tel
      klass = Class.new(@test_class)
      klass.name :vcard
      assert_equal @test_class.properties, klass.properties
      assert_equal @test_class.instance_variable_get(:@has_one), klass.instance_variable_get(:@has_one)
      assert_equal @test_class.instance_variable_get(:@has_many), klass.instance_variable_get(:@has_many)
      klass.has_one :foo
      assert !@test_class.properties.has_key?(:foo)
      assert klass.properties.has_key?(:foo)
      assert_respond_to klass.parse_first(@doc), :foo
    end
  end
  
  describe 'Instance' do
    setup do
      @klass = Class.new(Prism::POSH::Base)
      property = 'vcard'
      @doc = Nokogiri.parse(@html, 'http://foobar.com/')
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
      assert_equal "Mark Wunsch", vcard.fn[0]
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
    
    should 'recall the source (url) of the document' do
      vcard = @klass.new(@node)
      assert_respond_to vcard, :source
      assert_equal 'http://foobar.com/', vcard.source
    end
    
    should 'convert hash representation to yaml' do
      @klass.has_one :fn
      @klass.has_many(:tel) { extract :typevalue }
      vcard = @klass.new(@node)
      assert_respond_to vcard, :to_yaml
      yaml = YAML.load(vcard.to_yaml)
      assert_equal 'CommerceNet', yaml[:fn]
    end
    
  end
end