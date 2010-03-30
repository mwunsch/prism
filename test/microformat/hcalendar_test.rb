require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCalendarTest < Test::Unit::TestCase
  @@klass = Prism::Microformat::HCalendar
  
  # http://ufxtract.com/testsuite/hcalendar/hcalendar1.htm
  describe 'single occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar1.html')
      @vcalendar ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcalendar ||= self.class.before_all
    end
    
    test 'The summary is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal "Barcamp Brighton 1", vevent[0].summary
    end
    
    test 'The duration is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal "P2D", vevent[0].duration
    end
    
    test 'The dtstart is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal Time.parse('2007-09-08'), vevent[0].dtstart
    end
    
    test 'The dtend is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal Time.parse('2007-09-09'), vevent[0].dtend
    end
    
    test 'The location is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'Madgex Office, Brighton', vevent[0].location
    end
    
    test 'The description is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'Barcamp is an ad-hoc gathering born from the desire to share and learn in an open environment.', vevent[0].description
    end
    
    test 'The url is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'http://www.barcampbrighton.org/', vevent[0].url
    end
    
    test 'The class is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'public', vevent[0][:class]
    end
    
    test 'The class is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'public', vevent[0][:class]
    end
    
    test 'The dtstamp is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal Time.parse('2007-05-01'), vevent[0].dtstamp
    end
    
    test 'The last-modified is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal Time.parse('2007-05-02'), vevent[0].last_modified
    end
    
    test 'The uid is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'guid1.example.com', vevent[0].uid
    end
    
    test 'The status is a singular value' do
      vevent = @vcalendar.vevent
      assert_equal 'Confirmed', vevent[0].status
    end
    
    test 'The geo is a singular value' do
      vevent = @vcalendar.vevent
      assert vevent[0].has_property? :geo
    end
    
    test 'The contact is a singular value' do
      vevent = @vcalendar.vevent
      assert vevent[0].has_property? :contact
    end
    
    test 'The organizer is a singular value' do
      vevent = @vcalendar.vevent
      assert vevent[0].has_property? :organizer
    end
    
  end  

  # http://ufxtract.com/testsuite/hcalendar/hcalendar2.htm
  describe 'multiple occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar2.html')
      @vcalendar ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcalendar ||= self.class.before_all
    end
    
    test 'The category is a multiple value' do
      vevent = @vcalendar.vevent
      assert_equal 'Unconference', vevent[0].category[1]
    end
    
    # The test fixture tests for rrule and rdate, but these values aren't in the fixture
    
    test 'The attendee is a multiple value' do
      vevent = @vcalendar.vevent
      assert vevent[0].has_property? :attendee
    end
    
  end
end