require File.join(File.dirname(__FILE__),'..','test_helper')

class ValueClassPatternTest < Test::Unit::TestCase
  setup do
    @pattern = Prism::Pattern::ValueClass    
  end
  
  test 'value-dt-test-YYYY-MM-DD--HH-MM' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM.html')
    doc = Nokogiri.parse(html)
    doc_dtstart = doc.css('.dtstart').first
    doc_dtend = doc.css('.dtend').first
    
    dtstart = @pattern.extract_from(doc_dtstart)
    dtend = @pattern.extract_from(doc_dtend)
    assert_equal Time.parse('2009-06-26T19:00'), dtstart
    assert_equal Time.parse('2009-06-26T22:00'), dtend
  end
  
  test 'value-dt-test-abbr-YYYY-MM-DD--HH-MM' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-abbr-YYYY-MM-DD--HH-MM.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc)
    assert_equal Time.parse('2008-06-24T18:30"'), dtstart
  end
  
  test 'value-dt-test-abbr-YYYY-MM-DD-abbr-HH-MM' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-abbr-YYYY-MM-DD-abbr-HH-MM.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc)
    assert_equal Time.parse('2009-06-05T20:00'), dtstart
  end
  
  test 'value-dt-test-YYYY-MM-DD--HHpm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HHpm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-06-26T19:00'), dtstart
    assert_equal Time.parse('2009-06-26T22:00'), dtend
  end
  
  test 'value-dt-test-YYYY-MM-DD--Hpm-EEpm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--Hpm-EEpm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-06-26T19:00")'), dtstart
    # There is an issue with this test, in that it tests an hCalendar implementation, and not just
    # ValueClass implementation: http://microformats.org/wiki/value-dt-test-YYYY-MM-DD--Hpm-EEpm
  end
  
  test 'value-dt-test-YYYY-MM-DD--abbr-HH-MMpm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--abbr-HH-MMpm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-06-26T19:30'), dtstart
  end
  
  test 'value-dt-test-YYYY-MM-DD--12am-12pm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--12am-12pm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-06-26T00'), dtstart
    assert_equal 12, dtend.hour
  end
  
  test 'value-dt-test-YYYY-MM-DD--H-MMam-Epm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--H-MMam-Epm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-07-26T09:30'), dtstart
    assert_equal 18, dtend.hour
  end
  
  test 'value-dt-test-YYYY-MM-DD--0Ham-EEam' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--0Ham-EEam.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-07-26T09:00'), dtstart
    assert_equal 10, dtend.hour
  end
  
  test 'value-dt-test-YYYY-MM-DD--H-MM-SSpm-EE-NN-UUpm' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--H-MM-SSpm-EE-NN-UUpm.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-06-26T19:01:23'), dtstart
    assert_equal 22, dtend.hour
    assert_equal 12, dtend.min
    assert_equal 34, dtend.sec
  end
  
  test 'value-dt-test-YYYY-DDD--HH-MM-SS' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-DDD--HH-MM-SS.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    
    assert_equal Time.parse('2009-10-03T17:09:34'), dtstart
  end
  
  test 'value-dt-test-YYYY-MM-DD--HH-MMZ-EE-NN-UUZ' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MMZ-EE-NN-UUZ.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-07-26T16:04Z'), dtstart
    assert_equal 0, dtend.utc_offset
    assert_equal 17, dtend.hour
    assert_equal 18, dtend.min
    assert_equal 19, dtend.sec
  end
  
  test 'value-dt-test-YYYY-MM-DD--HH-MM-XX-YY--EE-NN-UU--XXYY' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM-XX-YY--EE-NN-UU--XXYY.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-07-26T10:04-06:00'), dtstart
  end
  
  test 'value-dt-test-YYYY-MM-DD--HH-MM-XX--EE-NN-UU--Y' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM-XX--EE-NN-UU--Y.html')
    doc = Nokogiri.parse(html)
    
    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)
    
    assert_equal Time.parse('2009-07-26T22:04+06'), dtstart
  end
  
  test 'value-dt-test-YYYY-MM-DD--HH-MM-SS-XXYY--EE-NN--Z' do
    html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM-SS-XXYY--EE-NN--Z.html')
    doc = Nokogiri.parse(html)

    dtstart = @pattern.extract_from(doc.css('.dtstart').first)
    dtend = @pattern.extract_from(doc.css('.dtend').first)

    assert_equal Time.parse('2009-07-26T22:04:15+0600'), dtstart
  end
  
end