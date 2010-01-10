require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @node = Nokogiri::HTML.parse(@html).css('.'+HMachine::Microformat::HCard::ROOT_CLASS)[0]
    @hcard = HMachine::Microformat::HCard.new(@node)
  end
  
  test "wiki url" do
    assert @hcard.class.wiki_url == "http://microformats.org/wiki/hcard"
  end
  
  test "validation" do
    assert @hcard.class.validate(@node)
  end
  
  test "root" do
    assert @hcard.class.root == @hcard.class::ROOT_CLASS
  end
  
  test "rejects invalid nodes" do
    assert_raise RuntimeError do 
      HMachine::Microformat::HCard.new(Nokogiri::HTML.parse(@html)) 
    end
  end
  
  test 'retains original node' do
    assert @hcard.node == @node
  end
  
  test 'something' do
    
    @hcard.class.search_for :fn, @node
  end

end