require File.join(File.dirname(__FILE__), 'test_helper')

class HMachineTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html)
  end
  
  describe 'Class Level Methods' do
    should 'normalize names' do
      assert_equal :hcard, HMachine.normalize("hCard")
    end
  end
  
  describe 'Module' do
    setup do
      @klass = Class.new.send(:include, HMachine)
    end
    
    should 'define a function to search nodes' do
      test = @klass.new
      test.search {|node| node.css('div') }
      assert_respond_to test.search, :call
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
    
    should 'define parsers to use with' do
      test = @klass.new
      test.extract {|node| node.content }
      assert !test.parsers.empty?, "Parsers are empty."
    end
    
    should 'extract with a block if a block is given' do
      test = @klass.new
      assert_respond_to test.extract{|node| node.content }.first, :call
    end
    
    should 'extract with a lambda if a lambda is given' do
      test = @klass.new
      func = lambda{|node| node.content }
      test.extract func
      assert test.parsers.include?(func), "Parsers include #{test.parsers.inspect}"
    end
    
    should 'extract with a pattern if a pattern is given' do
      test = @klass.new
      test.extract :valueclass
      assert_respond_to test.parsers.first, :call
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
    
    should 'try each parser until one works' do
      test = @klass.new
      funcs = (1..5).collect { lambda{ nil } }
      funcs[2] = lambda{|node| node.css('a.fn').first['href'] }
      test.extract *funcs
      assert_equal test.parsers[2].call(@doc), test.extract_from(@doc)
    end
    
    should 'ignore other parsers if it finds one that works' do
      test = @klass.new
      foobar = false
      funcs = (1..3).collect { lambda{ nil } }
      funcs[0] = lambda{|node| node.css('.fn').first['href'] }
      funcs[1] = lambda{foobar = true}
      test.extract *funcs
      assert !foobar, "The value of foobar is #{foobar}"
    end
    
    should 'if all the parsers return false, just return the contents of the node' do
      test = @klass.new
      funcs = (1..3).collect { lambda{nil} }
      test.extract *funcs
      assert_equal @doc.content.strip, test.extract_from(@doc)
    end
    
    should "parse a node, extracting its contents" do
      test = @klass.new
      test.search {|node| node.css('.fn') }
      assert_equal @doc.css('.fn').first.content, test.parse(@doc)
    end
    
    should 'parse a node, and return an array of contents' do
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