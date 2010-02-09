require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PoshAnchorTest < Test::Unit::TestCase
  setup do
    @html = '<a href="http://something.com" rel="me friend" title="This is a link" type="good">Link to something</a>'
    @doc = Nokogiri.parse(@html)
  end
  
  should 'parse all anchor tags from a document' do
    link = HMachine::POSH::Anchor.parse(@doc)
    assert_equal HMachine::POSH::Anchor, link.class
  end
  
  should 'have rel values' do
    link = HMachine::POSH::Anchor.parse(@doc)
    assert_respond_to link, :rel
    assert_equal 2, link.rel.count
    assert_equal 'me', link.rel.first
  end
  
  should 'have a url' do
    link = HMachine::POSH::Anchor.parse(@doc)
    assert_respond_to link, :url
    assert_equal 'http://something.com', link.url
  end
  
  should 'have some text' do
    link = HMachine::POSH::Anchor.parse(@doc)
    assert_respond_to link, :text
    assert_respond_to link, :content
    assert_equal 'Link to something', link.text
    assert_equal link.text, link.content
  end
  
  should 'have a title' do
    link = HMachine::POSH::Anchor.parse(@doc)
    assert_respond_to link, :type
    assert_equal 'good', link.type
  end
  
end