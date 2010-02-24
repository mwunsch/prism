require File.join(File.dirname(__FILE__), 'test_helper')

class PatternTest < Test::Unit::TestCase
  describe 'Mapper' do
    should 'map a symbol to a design pattern' do
      assert Prism::Pattern::ValueClass, Prism::Pattern.map(:value_class)
    end
  end
  
  describe 'URI Design Pattern' do
    should 'have an extraction method' do
      assert_respond_to Prism::Pattern::URL, :extract
    end
    
    should 'normalize URLs' do
      assert_respond_to Prism::Pattern::URL, :normalize
      assert_equal 'http://foobar.com/', Prism::Pattern::URL.normalize('http://foobar.com')
    end
    
    should 'extract the href out of an a element' do
      doc = Nokogiri.parse('<a href="http://foobar.com">Hello</a>')
      a = doc.css('a').first
      assert_equal 'http://foobar.com/', Prism::Pattern::URL.extract_from(a)
    end
    
    should 'extract the src out of an img element' do
      doc = Nokogiri.parse('<img src="http://foobar.com" alt="Foobar" />')
      img = doc.css('img').first
      assert_equal 'http://foobar.com/', Prism::Pattern::URL.extract_from(img)
    end
  end
  
  describe 'Type/Value Pattern' do
    setup do
      @html = get_fixture('test-fixture/hcard/hcard6.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
    end
    
    should 'extract the type and value of an element' do
      html = Nokogiri.parse(%Q{<span class="email">
	      <span class="type">internet</span> 
	      <a href="mailto:notthis@example.com">john@example.com</a>
      </span>})
      doc = html.css('.email').first
      type_value = Prism::Pattern::TypeValue.extract_from(doc)
      assert type_value.has_key?(:type)
      assert_equal :internet, type_value[:type]
      assert_equal 'john@example.com', type_value[:value]
    end
  end
  
  describe 'Abbr Design Pattern' do
    should 'have an extraction method' do
      assert_respond_to Prism::Pattern::Abbr, :extract
    end
    
    should 'extract the title out of an abbreviation element' do
      doc = Nokogiri.parse('<abbr title="Hello machine">Hello Human</abbr>')
      node = doc.css('abbr').first
      assert_equal 'Hello machine', Prism::Pattern::Abbr.extract_from(node)
    end
    
    should 'continue as usual if no title is found' do
      doc = Nokogiri.parse('<abbr>Hello human</abbr>')
      node = doc.css('abbr').first
      assert_equal 'Hello human', Prism::Pattern::Abbr.extract_from(node)
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
      assert Prism::Pattern::ValueClass.found_in?(doc)
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
      assert_equal 1, Prism::Pattern::ValueClass.find_in(doc).size
      assert_not_equal 'Puppies Rule!', Prism::Pattern::ValueClass.extract_from(doc)
      assert Prism::Pattern::ValueClass.valid?(Prism::Pattern::ValueClass.find_in(doc).first)
    end
    
    should 'extract the value' do
      doc = Nokogiri.parse(%q{<p class="description"><span class="value">Value Class Pattern</span></p>})
      assert_equal 'Value Class Pattern', Prism::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'concatenate values' do
      doc = Nokogiri.parse(%q{
        <span class="tel">
          <span class="type">Home</span>:
          <span class="value">+44</span> (0) <span class="value">1223 123 123</span>
        </span>
      })
      assert_equal '+441223 123 123', Prism::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'extract the value intelligently from an abbr element' do
      doc = Nokogiri.parse(%q{<span class="dtstart"><abbr class="value" title="hello">this Tuesday</abbr></span>})
      assert_not_equal 'this Tuesday', Prism::Pattern::ValueClass.extract_from(doc)
      assert_equal 'hello', Prism::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'use the alt attribute for images or areas' do
      doc = Nokogiri.parse(%q{<div class="photo">Here's me: <img src="photo.jpg" class="value" alt="Whatever" /></div>})
      assert_equal "Whatever", Prism::Pattern::ValueClass.extract_from(doc)
    end
    
    should 'understand the value-title pattern' do
      doc = Nokogiri.parse(%q{
      <span class="dtstart">
        <span class="value-title" title="hi"> </span>
        Friday, June 5th at 8pm
      </span>})
      assert_equal 'hi', Prism::Pattern::ValueClass.extract_from(doc)
    end
    
  end
end