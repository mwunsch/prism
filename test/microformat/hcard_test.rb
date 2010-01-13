require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri::HTML.parse(@html)
  end
  
  describe 'Class' do
    should 'inherit from Base' do
      assert_equal HMachine::Microformat::Base, HMachine::Microformat::HCard.superclass
    end
    
    should 'have a url to a wiki page' do
      assert_equal "http://microformats.org/wiki/hcard", HMachine::Microformat::HCard.wiki_url
    end
    
    should 'have a root class to search for' do
      assert_equal "vcard", HMachine::Microformat::HCard.root
    end
    
    should 'find itself in a document' do
      assert_equal 1, HMachine::Microformat::HCard.find_in(@doc).length
    end
  end
  
  describe 'Instance' do
    setup do
      @node = HMachine::Microformat::HCard.find_in(@doc).first
    end
    
    should 'validate the node' do
      assert_nothing_raised do
        HMachine::Microformat::HCard.new(@node)
      end      
    end
    
    should 'have one fn' do
      test = HMachine::Microformat::HCard.new(@node)
      assert_respond_to test, :fn
    end
    
    should 'have one n' do
      test = HMachine::Microformat::HCard.new(@node)
      assert_respond_to test, :n
    end
  end
  
  describe 'Parsing' do
    setup do
      @node = HMachine::Microformat::HCard.find_in(@doc).first
      @hcard = HMachine::Microformat::HCard.new(@node)
    end
  end

end