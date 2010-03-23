require File.join(File.dirname(__FILE__), 'test_helper')

class PrismTest < Test::Unit::TestCase
  setup do
    FakeWeb.register_uri(:get, "http://markwunsch.com/", :body => "Nothing to be found 'round here")
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html)
  end
  
  teardown do
    FakeWeb.clean_registry
  end
  
  describe 'Class Level Methods' do
    should 'normalize names' do
      assert_equal :hcard, Prism.normalize("hCard")
    end
    
    should 'map symbol names to Extraction methods' do
      assert_equal Prism::Pattern::ValueClass, Prism.map(:valueclass)
    end
    
    should 'parse an html document into a Nokogiri doc' do
      assert Prism.get_document('<div id="hello">World</div').is_a?(Nokogiri::XML::Node)
    end
    
    should 'open a url and get the document' do
      doc = Prism.get_url('http://markwunsch.com')
      assert doc.is_a?(Nokogiri::XML::Document)
      assert_equal "Nothing to be found 'round here", doc.text
    end
    
    should 'get a document with a url or a string of html' do
      doc = Prism.get('http://markwunsch.com')
      assert doc.is_a?(Nokogiri::XML::Document)
      assert_equal 'http://markwunsch.com/', doc.url
      assert Prism.get('<p>Hello world</p>').is_a?(Nokogiri::XML::Document)
    end
    
    should 'find all microformats in a document' do
      huffduff = Prism.find get_fixture('huffduffer.html')
      assert_equal 45, huffduff.count
    end
    
    should 'find a specific format in a document' do
      huffduff = get_fixture('huffduffer.html')
      hcards = Prism.find huffduff, :hcard
      assert_equal 10, hcards.count
    end
  end
  
  describe 'Module' do
    setup do
      @klass = Class.new.send(:include, Prism)
    end
    
    should 'define a function to search nodes' do
      test = @klass.new
      test.search {|node| node.css('div') }
      assert_respond_to test.search, :call
    end
    
    should 'search for a specific selector in a node' do
      test = @klass.new
      test.search_for 'div'
      assert_respond_to test.search_for, :call 
    end
    
    should 'find an element in a node' do
      test = @klass.new
      test.search {|node| node.css('div') }
      assert test.find_in(@doc).is_a?(Nokogiri::XML::NodeSet), "Search resulted in #{test.find_in(@doc).class}"
    end
    
    should 'test if an element can be found in a node' do
      test = @klass.new
      test.search {|node| node.css('foobar') }
      assert !test.found_in?(@doc)
    end
    
    should 'define a function to validate nodes' do
      test = @klass.new
      test.validate {|node| true if node }
      assert_respond_to test.validate, :call
    end
    
    should 'have a smart default validation method' do
      test = @klass.new
      node = @doc.css('.vcard').first
      assert test.validate.call(node)
    end
    
    should 'test if a node is valid' do
      test = @klass.new
      node = @doc.css('.vcard').first
      test.validate { |node| node['class'] == 'vcard' }
      assert test.valid?(node)
    end
    
    should 'define an extraction method' do
      test = @klass.new
      test.extract {|node| node.content }
      assert_respond_to test.extract, :call
    end
    
    should 'extract node content if no parsers are defined' do
      test = @klass.new
      assert_equal @doc.content.strip, test.extract_from(@doc)
    end
    
    should 'attempt to use a parser to extract content from node' do
      test = @klass.new
      test.extract {|node| node.css('a.fn').first['href'] }
      assert_equal @doc.css('a.fn').first['href'], test.extract_from(@doc)
    end
    
    should "parse a node, extracting its contents" do
      test = @klass.new
      test.search {|node| node.css('.fn') }
      assert_equal @doc.css('.fn').first.content, test.parse(@doc).first
    end
    
    should 'parse a document, and return an array of contents' do
      test = @klass.new
      tel_type = @doc.css('.tel > .type').collect {|node| node.content }
      test.search {|node| node.css('.tel') }
      test.extract {|node| node.css('.type').first.content }
      assert_equal tel_type, test.parse(@doc)
    end
    
    should 'parse the first instance of an element in a node' do
      test = @klass.new
      tel_type = @doc.css('.tel > .type').collect {|node| node.content }
      test.search {|node| node.css('.tel') }
      test.extract {|node| node.css('.type').first.content }
      assert_equal tel_type.first, test.parse_first(@doc)
    end
    
  end
end