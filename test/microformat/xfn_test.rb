require File.join(File.dirname(__FILE__), '..', 'test_helper')

class XFNTest < Test::Unit::TestCase
  setup do
    html = get_fixture('xfn.html')
    @doc = Nokogiri::HTML.parse(html)
    @klass = Prism::Microformat::XFN
  end
  
  should 'search the document for relationships' do
    contact = @klass.parse_first(@doc)
    assert_respond_to contact, :rel
    contact.rel.include? 'contact'
  end
  
  should 'define boolean methods' do
    contact = @klass.parse_first(@doc)
    assert_respond_to contact, :friendship?
    assert_respond_to contact, :me?
    assert contact.friendship?
  end
  
  should 'be able to parse just "me" relationships' do
    me = @klass.parse_me(@doc)
    assert me.first.me?
  end
  
end
