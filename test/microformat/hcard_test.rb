require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri::HTML.parse(@html)
    @klass = HMachine::Microformat::HCard
  end
  
  should 'parse itself from a document' do
    hcard = @klass.parse(@doc)
    assert_respond_to hcard, :fn
    assert hcard.node['class'].include?('vcard')
  end
  
  should 'have an fn' do
    hcard = @klass.parse(@doc)
    assert_equal 'CommerceNet', hcard.fn
  end

end