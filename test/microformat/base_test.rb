require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BaseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @node = Nokogiri::HTML.parse(@html).css('.'+HMachine::Microformat::HCard::ROOT_CLASS)[0]
    @hcard = HMachine::Microformat::Base.new(@node)
    @nested = '<div class="vcard"><span class="fn">Mark Wunsch</span> and <div class="vcard"><span class="fn">Somebody else</span></div></div>'
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
    
    test 'validator defaults to checking root class name against attribute' do
      @test_class.root 'vcard'
      assert @test_class.validator.call @node
    end
    
    test 'can define a new validator' do
      @test_class.validator { false }
      assert !@test_class.validator.call
    end
    
    test 'validates against supplied validator' do
      @test_class.validator { "win" }
      assert @test_class.validate(@node) == "win"
    end
    
    test 'defines how to search for the microformat' do
      @test_class.search { true }
      assert @test_class.search.call
    end
    
    test 'performs a search against a document' do
      @test_class.search {|doc| doc.css('.vcard') }
      assert @test_class.find_in(Nokogiri::HTML.parse(@html)).respond_to? :length
    end
    
    test 'defines a root class name' do
      @test_class.root 'vcard'
      assert @test_class.root == 'vcard'
    end
    
    test 'searches for a property in a microformat' do
      @test_class.root 'vcard'
      node = @test_class.find_in(Nokogiri::HTML.parse(@nested))[0]
      test = @hcard.class.new(node)
      assert @test_class.search_for(:fn, node)[0].content == "Mark Wunsch"
    end
    
    test 'does not search for properties within a nested microformat' do
      @test_class.root 'vcard'
      node = @test_class.find_in(Nokogiri::HTML.parse(@nested))[0]
      test = @hcard.class.new(node)
      assert @test_class.search_for(:fn, node).length == 1
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