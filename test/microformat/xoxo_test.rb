require File.join(File.dirname(__FILE__), '..', 'test_helper')

class XOXOTest < Test::Unit::TestCase
  setup do
    html = get_fixture('xoxo.html')
    doc = Nokogiri::HTML.parse(html)
    @klass = Prism::Microformat::XOXO
    @node = @klass.find_in(doc).first
  end
    
  should 'construct an outline' do
    test = @klass.new(@node)
    assert_equal 5, test.outline.count
  end
  
  should 'convert to an array easily' do
    test = @klass.new(@node)
    assert_equal test.outline, test.to_a
  end
  
  should 'index quickly into the outline' do
    test = @klass.new(@node)
    assert_equal test.to_a[0], test[0]
  end
  
  should 'convert list items to an array' do
    test = @klass.new(@node)
    assert_instance_of Array, test[0]
  end
  
  should 'convert lists to arrays' do
    test = @klass.new(@node)
    assert_instance_of Array, test[0][1]
  end
  
  should 'convert definition lists to hashes' do
    test = @klass.new(@node)
    assert test[3].first.has_key?("description"), "Definition List is: #{test[3].first.inspect}"
  end
  
  should 'convert links to hashes' do
    test = @klass.new(@node)
    assert test[4].first.has_key?(:url), "Definition List is: #{test[4].first.inspect}"
  end
  
  should 'know if this is a blogroll' do
    test = @klass.new(@node)
    assert !test.blogroll?, "Test is a blogroll"
  end    
  
end