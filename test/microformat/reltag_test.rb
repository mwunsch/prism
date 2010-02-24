require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RelTagTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('huffduffer.html')
    @doc = Nokogiri::HTML.parse(@html)
  end
  
  describe 'Class' do    
    should 'find itself in a document' do
      first_entry = @doc.css('.hfeed > .hentry').first
      assert_equal 8, Prism::Microformat::RelTag.find_in(first_entry).count
    end
    
    should 'parse itself out of a document' do
      first_entry = @doc.css('.hfeed > .hentry').first
      assert_equal Prism::Microformat::RelTag, Prism::Microformat::RelTag.parse(first_entry).first.class
    end
  end
  
  describe 'Instance' do
    setup do
      @klass = Prism::Microformat::RelTag
      first_entry = @doc.css('.hfeed > .hentry').first
      @node = @klass.find_in(first_entry).first
    end
    
    should 'have a name that is the tag' do
      test = @klass.new(@node)
      assert_equal test.tag.keys.first, test.name
    end
    
    should 'convert to a string easily' do
      test = @klass.new(@node)
      assert_equal test.name, "#{test}"
    end
    
    should 'store the url for the tag' do
      test = @klass.new(@node)
      assert_equal test.tag.values.first, test.url
    end
    
    should 'hash should be a representation of the tag' do
      test = @klass.new(@node)
      assert_equal test.tag, test.to_h
    end
  end
  
  describe 'Parsing' do
    setup do
      @klass = Prism::Microformat::RelTag
    end
    
    should "get a tag" do
      first_entry = @doc.css('.hfeed > .hentry').first
      test = @klass.new(@klass.find_in(first_entry).first)
      assert_equal "event%3Aspeaker%3Dtim+o%27reilly", test.tag.keys.first
    end
  end  
  
end