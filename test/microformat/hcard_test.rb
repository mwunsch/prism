require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  describe 'single occurence test' do
    setup do
      @html = get_fixture('test-fixture/hcard/hcard1.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
      @klass = HMachine::Microformat::HCard
    end
    
    test 'The fn (formatted name) is a singular value' do
      vcard = @klass.parse_first(@doc)
      assert_respond_to vcard, :fn
      assert_equal 'John Doe', vcard.fn
    end
    
    test 'The n (name) is a singular value' do
      vcard = @klass.parse_first(@doc)
      assert_respond_to vcard, :n
      assert vcard.has_property?(:n)
    end
  end

end