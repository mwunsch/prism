require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @node = Nokogiri::HTML.parse(@html).css(HMachine::Microformat::HCard::ROOT_SELECTOR)[0]
    @hcard = HMachine::Microformat::Base.new(@node)
  end
  
  describe 'Class' do
    setup do
      @test_class = Class.new(@hcard.class)
    end
    
    test 'inherits from Base' do
      assert @test_class.superclass == @hcard.class
    end
    
    test 'defines a wiki url' do
      @test_class.wiki_url 'http://microformats.org/wiki'
      assert @test_class.wiki_url == 'http://microformats.org/wiki'
    end
    
    test 'validator defaults to true' do
      assert @test_class.validator.call
    end
    
    test 'can define a new validator' do
      @test_class.validator { false }
      assert !@test_class.validator.call
    end
    
    test 'validates against supplied validator' do
      @test_class.validator { "win" }
      assert @test_class.validate(@node) == "win"
    end
  end
  
  describe 'Instance' do
    test 'possesses an html node' do
      assert @hcard.node == @node
    end
    
    test 'converts its node to an html representation' do
      assert @hcard.to_s == @node.to_s
    end
    
    test 'also has a convenience method to convert to html' do
      assert @hcard.to_html == @node.to_html
    end
  end
  
end