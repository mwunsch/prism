require File.join(File.dirname(__FILE__),'..','test_helper')

class ValueClassPatternTest < Test::Unit::TestCase
  setup do
    @pattern = Prism::Pattern::ValueClass    
  end
  
  should 'concatenate two html elements to create one datetime value' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM.html')
    doc = Nokogiri.parse(html)
    doc_dtstart = doc.css('.dtstart').first
    doc_dtend = doc.css('.dtend').first
    
    dtstart = @pattern.extract_from(doc_dtstart)
    dtend = @pattern.extract_from(doc_dtend)
    assert_equal Time, dtstart.class
    assert_equal 2009, dtstart.year
    assert_equal 6, dtstart.mon
    assert_equal 26, dtstart.day
    assert_equal 19, dtstart.hour
    assert_equal 22, dtend.hour
  end
  
  should 'concatenate abbr title attribute and the text from a span element to create one datetime value' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-abbr-YYYY-MM-DD--HH-MM.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc)
    assert_equal 2008, dtstart.year
    assert_equal 2, dtstart.wday
  end
  
end