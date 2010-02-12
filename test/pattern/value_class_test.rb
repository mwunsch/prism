require File.join(File.dirname(__FILE__),'..','test_helper')

class ValueClassPatternTest < Test::Unit::TestCase
  setup do
    @pattern = HMachine::Pattern::ValueClass
      html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM.html')
      @doc = Nokogiri.parse(html)
      @dtstart = @doc.css('.dtstart').first
      @dtend = @doc.css('.dtend').first
  end
  
  should 'Build easy datetime strings' do
    assert_equal '2010-2-14', @pattern.datetime('February 14 2010')
    assert_equal 'T15:0:0EST', @pattern.datetime('3:00pm')
    assert_equal 'Hello world', @pattern.datetime('Hello world')
  end
  
  should 'get the value text out of an element' do
    
  end
  
end