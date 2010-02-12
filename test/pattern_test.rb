require File.join(File.dirname(__FILE__), 'test_helper')

class PatternTest < Test::Unit::TestCase
  describe 'Mapper' do
    should 'map a symbol to a design pattern' do
      assert HMachine::Pattern::ValueClass, HMachine::Pattern.map(:value_class)
    end
  end
  
  describe 'DateTime parsing' do
    should 'validate a DateTime string' do
      assert HMachine::Pattern::DateTime.valid?('2010-02-14')
      assert !HMachine::Pattern::DateTime.valid?('Hello World!')
    end
    
    should 'convert a datetime string to a Time object' do
      valentines_day = HMachine::Pattern::DateTime.extract_from('2010-02-14')
      afternoon = HMachine::Pattern::DateTime.extract_from('16:30')
      assert_equal Time, valentines_day.class
      assert_equal 2010, valentines_day.year
      assert_equal 16, afternoon.hour
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
  
  describe 'Value Class Pattern' do
    # http://microformats.org/wiki/value-class-pattern-tests
    should 'find value class in a document' do
      doc = Nokogiri.parse(%q{
        <span class="tel">
          <span class="type">Home</span>:
          <span class="value">+44</span> (0) <span class="value">1223 123 123</span>
        </span>
      })
      assert HMachine::Pattern::ValueClass.found_in?(doc)
    end
    
    should 'ignore nested value classes' do
      doc = Nokogiri.parse(%q{
        <p class="description">
          <span class="value">
            <em class="value">Puppies Rule!</em>
            <strong>But kittens are better!</strong>
         </span>
        </p>
      })
      assert_equal 1, HMachine::Pattern::ValueClass.find_in(doc).size
      assert_not_equal 'Puppies Rule!', HMachine::Pattern::ValueClass.extract_from(doc)
      assert HMachine::Pattern::ValueClass.valid?(HMachine::Pattern::ValueClass.find_in(doc).first)
    end
    
    should 'extract the value' do
      doc = Nokogiri.parse(%q{<p class="description"><span class="value">Value Class Pattern</span></p>})
      assert_equal 'Value Class Pattern', HMachine::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'concatenate values' do
      doc = Nokogiri.parse(%q{
        <span class="tel">
          <span class="type">Home</span>:
          <span class="value">+44</span> (0) <span class="value">1223 123 123</span>
        </span>
      })
      assert_equal '+441223 123 123', HMachine::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'extract the value intelligently from an abbr element' do
      doc = Nokogiri.parse(%q{<span class="dtstart"><abbr class="value" title="2008-06-24">this Tuesday</abbr></span>})
      assert_not_equal 'this Tuesday', HMachine::Pattern::ValueClass.extract_from(doc)
      assert_equal '2008-06-24', HMachine::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'use the alt attribute for images or areas' do
      doc = Nokogiri.parse(%q{<div class="photo">Here's me: <img src="photo.jpg" class="value" alt="Whatever" /></div>})
      assert_equal "Whatever", HMachine::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'understand the value-title pattern' do
      doc = Nokogiri.parse(%q{
      <span class="dtstart">
        <span class="value-title" title="2009-06-05T20:00:00"> </span>
        Friday, June 5th at 8pm
      </span>})
      assert_equal '2009-06-05T20:00:00', HMachine::Pattern::ValueClass.extract_from(doc)
    end
    
  end
end