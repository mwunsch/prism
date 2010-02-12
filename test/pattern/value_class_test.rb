require File.join(File.dirname(__FILE__),'..','test_helper')

class ValueClassPatternTest < Test::Unit::TestCase
  setup do
    @pattern = HMachine::Pattern::ValueClass
  end
  
  # should 'contain a time' do
  #   html = get_fixture('test-fixture/value-class-date-time/value-dt-test-YYYY-MM-DD--HH-MM.html')
  #   doc = Nokogiri.parse(html)
  #   dtstart = doc.css('.dtstart').first
  #   dtend = doc.css('.dtend').first    
  #   assert_equal Time, @pattern.extract_from(dtstart).class
  #   p @pattern.extract_from(dtstart)
  # end
  
end