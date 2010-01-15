require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri::HTML.parse(@html)
    @nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
  end
  
  describe 'Class' do
    should 'be a subclass of Base' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_equal HMachine::Microformat::Base, test_class.superclass
    end
    
    should 'include the HMachine general parser' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_respond_to test_class, :extract
    end
    
    should 'define a root class name' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      assert_equal 'vcard', test_class.root
    end
    
    should 'define a wiki url' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.wiki_url 'http://microformats.org/wiki/hcard'
      assert_equal 'http://microformats.org/wiki/hcard', test_class.wiki_url
    end
    
    should 'have a default wiki url' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_equal 'http://microformats.org/wiki', test_class.wiki_url
    end
    
    should 'have a default search method' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      assert_equal test_class.root, test_class.search.call(@doc).first['class']
    end
    
    should 'have a default validate method' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      node = @doc.css('.vcard').first
      assert test_class.valid?(node)
    end
    
    should 'extract by creating a new instance' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      node = @doc.css('.vcard').first
      assert_instance_of test_class, test_class.extract.call(node)
    end
    
    should 'parse out all the microformats in a document' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      assert_instance_of test_class, test_class.parse(@doc)
    end
    
    should 'have a list of properties' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert test_class.properties.empty?, "Properties are #{test_class.properties.inspect}"
    end
    
    should 'finds a property by a key' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.has_one :fn, :n
      assert_equal test_class.properties[0], test_class.find_property(:fn)
    end
    
    should 'further define a property with a block' do
      test_class = Class.new(HMachine::Microformat::Base)
      func = lambda{ true }
      fn = test_class.add_properties([:fn], func).first
      assert_instance_of HMachine::Property, fn
    end
    
    should 'generate and add properties' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.add_properties([:fn])
      assert_equal :fn, test_class.properties.first.name
    end
    
    should 'search for property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      fn = HMachine::Property.new(:fn)
      assert_instance_of Nokogiri::XML::NodeSet, test_class.search_for(fn, @doc)
    end
    
    should 'remove nested microformats' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      fn = HMachine::Property.new(:fn)
      doc = test_class.find_in(Nokogiri::HTML.parse(@nested)).first
      assert_equal "Mark Wunsch", fn.parse(test_class.remove_nested(doc))
    end
    
    should "don't remove nested microformats if the microformat is the document" do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.search {|doc| doc }
      fn = HMachine::Property.new(:fn)
      doc = test_class.find_in(Nokogiri::HTML.parse(@nested))
      assert_equal 2, fn.parse(test_class.remove_nested(doc)).length
    end
    
    should 'not search for properties in nested microformats' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      fn = HMachine::Property.new(:fn)
      doc = test_class.find_in(Nokogiri::HTML.parse(@nested)).first
      assert_equal 1, test_class.search_for(fn, doc).length
    end
    
    should 'search in the document if the microformat is the document' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.search {|doc| doc }
      fn = HMachine::Property.new(:fn)
      doc = test_class.find_in(Nokogiri::HTML.parse(@nested))
      assert_equal 2, test_class.search_for(fn, doc).length
    end
    
    should 'get the first instance of a property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      tel = HMachine::Property.new(:tel)
      tel.extract {|node| node.css('.type').first.content.strip }
      doc = test_class.find_in(@doc).first
      assert_equal 'Work', test_class.get_one(tel, doc)
    end
    
    should 'get all the instances of a property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      tel = HMachine::Property.new(:tel)
      tel.extract { |node| node.css('.type').first.content.strip }
      doc = test_class.find_in(@doc).first
      assert_equal 2, test_class.get_all(tel, doc).length
    end
    
    should 'get all the instances of a property as a hash' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      tel = HMachine::Property.new(:tel)
      tel.extract do |node|
        {node.css('.type').first.unlink.content.strip.downcase.intern => node.content.strip}
      end
      doc = test_class.find_in(@doc).first
      assert_respond_to test_class.get_all(tel, doc), :keys
    end
    
    should 'define an instance method to get the first instance of a property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_one :tel
      hcard = test_class.find_in(@doc).first
      assert_respond_to test_class.new(hcard), :tel
    end
    
    should 'properties have one instance in a microformat' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_one :fn
      hcard = test_class.find_in(@doc).first
      assert_equal 'CommerceNet', test_class.new(hcard).fn
    end
    
    should 'define an instance method to get all instances of a property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_many :tel
      hcard = test_class.find_in(@doc).first
      assert_respond_to test_class.new(hcard), :tel
    end
    
    should 'properties have many instances in a microformat' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_many :tel do |tel|
        tel.extract do |node|
          {node.css('.type').first.unlink.content.strip.downcase.intern => node.content.strip}
        end
      end
      hcard = test_class.find_in(@doc).first
      test = test_class.new(hcard)
      assert_equal 2, test.tel.keys.length
    end
    
    should 'map properties if it gets one instance' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.has_one :fn
      assert test_class.one_or_many[:one].include?(:fn), "Has one: #{test_class.one_or_many[:one].inspect}"
    end
    
    should 'map properties if it gets many instances' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.has_many :tel
      assert test_class.one_or_many[:many].include?(:tel), "Has one: #{test_class.one_or_many[:many].inspect}"
    end
    
    should 'parse all properties in a node' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_many :tel
      hcard = test_class.find_in(@doc).first
      tel = test_class.find_property(:tel)
      assert_equal tel.parse(hcard), test_class.fetch_property_from_node(:tel, hcard)
    end
    
    should 'parse a single property from a node' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.has_one :fn
      hcard = test_class.find_in(@doc).first
      fn = test_class.find_property(:fn)
      assert_equal fn.parse(hcard), test_class.fetch_property_from_node(:fn, hcard)
    end
    
    should 'have a set of requirements' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.requires(:fn)
      assert test_class.requirements.include?(:fn), "Requirements include: #{test_class.requirements.inspect}"
    end
    
    should 'add requirements to properties' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.requires(:fn)
      properties = test_class.properties.collect {|p| p.name }
      assert properties.include?(:fn), "Properties include: #{properties.inspect}"
    end
    
    should 'requirements act like any other property' do
      test_class = Class.new(HMachine::Microformat::Base)
      test_class.root 'vcard'
      test_class.requires_at_least_one :tel do |tel|
        tel.extract do |node|
          {node.css('.type').first.unlink.content.strip.downcase.intern => node.content.strip}
        end
      end
      hcard = test_class.find_in(@doc).first
      test = test_class.new(hcard)
      assert_respond_to test, :tel
    end
    
    should 'have a message if this microformat is invalid' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_respond_to test_class, :invalid_msg
    end
    
  end
  
  describe 'Instance' do
      setup do
        @node = @doc.css('.vcard').first
        @klass = Class.new(HMachine::Microformat::Base)
        @klass.root 'vcard'
      end
      
      should 'possess an html node' do
        test = @klass.new(@node)
        assert_equal @node, test.node
      end
      
      should 'raise an error if this is an invalid microformat' do
        assert_raise RuntimeError do
          @klass.new(@doc)
        end
      end
      
      should 'raise an error if a requirement is missing' do
        test_class = Class.new(HMachine::Microformat::Base)
        test_class.root 'vcard'
        test_class.requires :foobar
        assert_raise RuntimeError do
          test_class.new(@node)
        end
      end
      
      should 'convert its node to an html representation' do
        test = @klass.new(@node)
        assert_equal @node.to_s, test.to_s
      end
      
      should 'have a convenience method to convert to html' do
        test = @klass.new(@node)
        assert_equal @node.to_html, test.to_html
      end
      
      should 'know what properties it has' do
        klass = Class.new(HMachine::Microformat::Base)
        klass.root 'vcard'
        klass.has_one :fn, :n
        hcard = klass.new(klass.find_in(@doc).first)
        assert !hcard.properties.include?(:n), "Properties contain: #{hcard.properties.inspect}"
      end
      
      should 'convert to a hash' do
        klass = Class.new(HMachine::Microformat::Base)
        klass.root 'vcard'
        klass.has_many :foobar, :tel do |tel|
          tel.extract do |node|
            {node.css('.type').first.unlink.content.strip.downcase.intern => node.content.strip}
          end
        end
        hcard = klass.new(klass.find_in(@doc).first)
        assert hcard.to_h.has_key?(:tel), "Hash equals #{hcard.to_h.inspect}"
      end
      
      should 'key into it like a hash' do
        klass = Class.new(HMachine::Microformat::Base)
        klass.root 'vcard'
        klass.has_one :fn, :n
        hcard = klass.new(klass.find_in(@doc).first)
        assert_equal hcard.fn, hcard[:fn]
      end
      
    end
  
end