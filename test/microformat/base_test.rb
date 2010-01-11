require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri::HTML.parse(@html)
    # @node = Nokogiri::HTML.parse(@html).css('.'+HMachine::Microformat::HCard::ROOT_CLASS)[0]
    # @hcard = HMachine::Microformat::Base.new(@node)
    @nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
  end
  
  describe 'Class' do
    should 'be a subclass of Base' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_equal HMachine::Microformat::Base, test_class.superclass
    end
    
    should 'include the HMachine general parser' do
      test_class = Class.new(HMachine::Microformat::Base)
      assert_respond_to test_class, :extract_with
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
    
  end
  
  describe 'Instance' do
    setup do
      @node = @doc.css('.vcard').first
      @klass = Class.new(HMachine::Microformat::Base)
    end
    
    should 'possess an html node' do
      test = @klass.new(@node)
      assert_equal @node, test.node
    end
    
    should 'convert its node to an html representation' do
      test = @klass.new(@node)
      assert_equal @node.to_s, test.to_s
    end
    
    should 'have a convenience method to convert to html' do
      test = @klass.new(@node)
      assert_equal @node.to_html, test.to_html
    end
  end
  
end