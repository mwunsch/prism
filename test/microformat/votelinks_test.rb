require File.join(File.dirname(__FILE__), '..', 'test_helper')

class VoteLinksTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('likeorhate.html')
    @doc = Nokogiri::HTML.parse(@html)
  end
  
  describe 'Class' do    
    should 'find itself in a document' do
      assert_equal 3, Prism::Microformat::VoteLinks.find_in(@doc).count
    end
  end
  
  describe 'Instance' do
    setup do
      @klass = Prism::Microformat::VoteLinks
      @node = @klass.find_in(@doc).first
    end
    
    should 'be a specific type of vote' do
      test = @klass.new(@node)
      assert_equal 'vote-for', test.type
    end
    
    should 'check vote type' do
      test = @klass.new(@node)
      assert test.for?, "VoteLink is type of #{test.type}"
      assert !test.against?
      assert !test.abstain?
    end
    
    should 'store the url of the vote' do
      test = @klass.new(@node)
      assert_equal 'http://likeorhate.com/rate/?id=1191956&rate=like', test.url
    end
    
    should "Additional human-readable commentary can be added using the existing 'title' attribute" do
      test = @klass.new(@node)
      assert_equal 'Do you like it? Click now and vote!', test.title
    end
    
  end
end