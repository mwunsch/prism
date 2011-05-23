require File.join(File.dirname(File.absolute_path(__FILE__)),'..','test_helper')

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

  # http://ufxtract.com/testsuite/hcalendar/hcalendar10.htm
  # This is particularly important as it also tests that other
  # microformats can be extracted.
  describe 'extracting contact test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar10.html')
      @vcalendar ||= @@klass.parse(@doc)
    end

    setup do
      @vcalendar ||= self.class.before_all
    end

    test 'The honorific-prefix is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "Dr", vevent[0].contact.n.honorific_prefix[0]
    end

    test 'The given-name is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "John", vevent[0].contact.n.given_name[0]
    end

    test 'The additional-name is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "Peter", vevent[0].contact.n.additional_name[0]
    end

    test 'The family-name is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "Doe", vevent[0].contact.n.family_name[0]
    end

    test 'The honorific-suffix is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "PHD", vevent[0].contact.n.honorific_suffix[1]
    end

    test 'The type is an optional multiple value. Types are case insensitive' do
      vevent = @vcalendar.vevent
      assert_equal :home, vevent[0].contact.adr[0].type[0]
    end

    test 'The post-office-box is an optional singular value' do
      vevent = @vcalendar.vevent
      assert_equal "PO Box 46", vevent[0].contact.adr[0].post_office_box
    end

    test 'The street-address is an optional multiple value' do
      vevent = @vcalendar.vevent
      assert_equal "West Street", vevent[0].contact.adr[0].street_address[1]
    end

    test 'The extended-address is an optional multiple value (Different from test suite use)' do
      vevent = @vcalendar.vevent
      assert_equal "Flat 2", vevent[0].contact.adr[0].extended_address[0]
    end

    test 'The region is an optional multiple value (Different from test suite use)' do
      vevent = @vcalendar.vevent
      assert_equal "East Sussex", vevent[0].contact.adr[0].region[0]
    end

    test 'The locality is an optional multiple value (Different from test suite use)' do
      vevent = @vcalendar.vevent
      assert_equal "Brighton", vevent[0].contact.adr[0].locality[0]
    end

    test 'The postal-code is an optional singular value' do
      vevent = @vcalendar.vevent
      assert_equal "BN1 3DF", vevent[0].contact.adr[0].postal_code
    end

    test 'The country-name is an optional multiple value (Different from test suite use)' do
      vevent = @vcalendar.vevent
      assert_equal "United Kingdom", vevent[0].contact.adr[0].country_name[0]
    end

    test 'Should collect the email address from href attribute' do
      vevent = @vcalendar.vevent
      assert_equal "john@example.com", vevent[0].contact.email[0]
      # FIX: Need to look at typevalue pattern so that above can read email[0].value
      # FIX: This seems messy to sometimes return a string, other times return a hash
    end

    test 'Should collect the telephone number from a descendant node with value property' do
      vevent = @vcalendar.vevent
      assert_equal "01273 700100", vevent[0].contact.tel[0][:value]
      # FIX: Need to look at typevalue pattern so that above can read tel[0].value
    end

    test 'Should collect the url value' do
      vevent = @vcalendar.vevent
      assert_equal "http://www.example.com/", vevent[0].contact.url[0]
    end
  end

  # hcalendar10a.html
  describe 'extracting contact without using hCard test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar10a.html')
      @vcalendar ||= @@klass.parse(@doc)
    end

    setup do
      @vcalendar ||= self.class.before_all
    end

    test 'The contact an optional singular value and can be a string' do
      vevent = @vcalendar.vevent
      assert_equal "Dr John Peter Doe", vevent[0].contact
    end
  end

  # Base on http://ufxtract.com/testsuite/hcalendar/hcalendar11.htm
  # with corrections
  describe 'extracting organizer and attendee test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar11.html')
      @vcalendar ||= @@klass.parse(@doc)
    end

    setup do
      @vcalendar ||= self.class.before_all
    end

    test 'The organizer given-name' do
      vevent = @vcalendar.vevent
      assert_equal "John", vevent[0].organizer.n.given_name[0]
    end

    test 'The organizer family-name' do
      vevent = @vcalendar.vevent
      assert_equal "Doe", vevent[0].organizer.n.family_name[0]
    end

    test 'The attendee fn value' do
      vevent = @vcalendar.vevent
      assert_equal "Jane Doe", vevent[0].attendee[1].fn
    end
  end

  # hcalendar11a.html
  describe 'extracting organizer and attendee without using hCard test' do
    def self.before_all
      @doc ||= test_fixture('hcalendar/hcalendar11a.html')
      @vcalendar ||= @@klass.parse(@doc)
    end

    setup do
      @vcalendar ||= self.class.before_all
    end

    test 'The organizer given-name' do
      vevent = @vcalendar.vevent
      assert_equal "John Doe", vevent[0].organizer
    end

    test 'The attendee fn value' do
      vevent = @vcalendar.vevent
      assert_equal "Jane Doe", vevent[0].attendee[1]
    end
  end
end
