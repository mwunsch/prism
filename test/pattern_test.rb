require File.join(File.dirname(__FILE__), 'test_helper')

class PatternTest < Test::Unit::TestCase
  describe 'Mapper' do
    should 'map a symbol to a design pattern' do
      assert HMachine::Pattern::ValueClass, HMachine::Pattern.map(:value_class)
    end
  end
  
  describe 'Abbr Design Pattern' do
    
    should 'have an extraction method' do
      assert_respond_to HMachine::Pattern::Abbr, :extract
    end
    
    should 'extract the title out of an abbreviation element' do
      doc = Nokogiri.parse('<abbr title="Hello machine">Hello Human</abbr>')
      node = doc.css('abbr').first
      assert_equal 'Hello machine', HMachine::Pattern::Abbr.extract_from(node)
    end
    
    should 'continue as usual if no title is found' do
      doc = Nokogiri.parse('<abbr>Hello human</abbr>')
      node = doc.css('abbr').first
      assert_equal 'Hello human', HMachine::Pattern::Abbr.extract_from(node)
    end
    
  end
end