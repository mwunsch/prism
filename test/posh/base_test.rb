require File.join(File.dirname(__FILE__), '..', 'test_helper')

class PoshTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('hcard/commercenet.html')
    @doc = Nokogiri.parse(@html)
  end
  
  describe 'Inheritance' do
    
    should 'parse itself out of a document' do
      test_class = Class.new(HMachine::POSH::Base)
      property = 'fn'
      test_class.search { |doc| doc.css(".#{property}") }
      test_class.validate { |node| node['class'] && node['class'].split(' ').include?(property) }
      assert_instance_of test_class, test_class.parse(@doc)
    end
    
  end
  
  describe 'Instance' do
    setup do
      @klass = Class.new(HMachine::POSH::Base)
      property = 'fn'
      @klass.search { |doc| doc.css(".#{property}") }
      @klass.validate { |node| node['class'] && node['class'].split(' ').include?(property) }
      @node = @klass.find_in(@doc).first
    end
    
    should 'have a node' do
      assert_equal @node, @klass.new(@node).node
    end
    
  end
end