require File.join(File.dirname(__FILE__),'..','test_helper')

class DateTimePatternTest < Test::Unit::TestCase
  setup do
    @pattern = HMachine::Pattern::DateTime
  end
  
  should 'recognize a simple iso8601 date' do
    assert @pattern.date?('2010-02-14')
    assert @pattern.date?('2010-185')
    assert !@pattern.date?('12:00pm')
  end
  
  should 'recognize a simple iso8601 time' do
    assert @pattern.time?('12:00')
    assert @pattern.time?('4:00pm')
    assert @pattern.time?('12:45:30Z')
    assert !@pattern.time?('2010-02-14')
  end
  
  should 'build an iso8601 date' do
    assert '2010-02-14', @pattern.date('February 14, 2010')
    assert_equal @pattern.date('July 4'), @pattern.date('2010-185')
    assert_equal '2010-1-1', @pattern.date('January 2010')
  end
  
  should 'build an iso8601 time' do
    assert_equal 'T12:0:0EST', @pattern.time('12:00')
    assert_equal 'T13:0:0EST', @pattern.time('1:00pm')
    assert_equal 'T4:45:30Z', @pattern.time('4:45:30Z')
    assert !@pattern.time('12')
  end
  
  should 'build a iso8601 timestamp' do
    assert_equal '2010-2-14', @pattern.iso8601('2010-02-14')
    assert_equal 'T4:45:30Z', @pattern.iso8601('4:45:30Z')
    assert_equal '2010-2-14T4:45:30Z', @pattern.iso8601('February 14 4:45:30Z')
    assert @pattern.iso8601('Hello world').empty?
  end
  
  should 'validate a DateTime string' do
    assert @pattern.valid?('2010-02-14')
    assert !@pattern.valid?('Hello World!')
  end
  
  should 'convert a datetime string to a Time object' do
    valentines_day = @pattern.extract_from('2010-02-14')
    afternoon = @pattern.extract_from('16:30')
    assert_equal Time, valentines_day.class
    assert_equal 2010, valentines_day.year
    assert_equal 16, afternoon.hour
  end
  
end