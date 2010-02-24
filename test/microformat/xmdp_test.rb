require File.join(File.dirname(__FILE__), '..', 'test_helper')

class XMDPTest < Test::Unit::TestCase
  setup do
    html = get_fixture('xmdp.html')
    doc = Nokogiri::HTML.parse(html)
    @klass = Prism::Microformat::XMDP
    @node = @klass.find_in(doc).first
  end
  
  should 'be just like a definition list' do
    xmdp = @klass.new(@node)
    assert xmdp.to_h.has_key?(:rel)
  end
  
end