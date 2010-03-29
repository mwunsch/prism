require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  @@klass = Prism::Microformat::HCard
  
  describe 'non test-fixture tests' do
    def self.before_all
      @doc ||= Nokogiri.parse(get_fixture('hcard/commercenet.html'))
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'be an organization' do
      assert @vcard[0].organization?
    end
    
    should 'convert to a vcard' do
      assert_respond_to @vcard[0], :to_vcard
    end
  end 
  
  # http://www.ufxtract.com/testsuite/hcard/hcard1.htm
  describe 'single occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard1.html')
      @vcard ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The fn (formatted name) is a singular value' do
      assert_respond_to @vcard, :fn
      assert @vcard.has_property?(:fn)
      assert_equal 'John Doe', @vcard.fn
    end
    
    test 'The n (name) is a singular value' do
      assert_respond_to @vcard, :n
      assert @vcard.has_property?(:n)
    end
    
    test 'The bday (birthday) is a singular value' do
      assert @vcard.has_property?(:bday)
      assert_equal 1, @vcard.bday.mon
      assert_equal 1, @vcard.bday.day
      assert_equal 2000, @vcard.bday.year
    end
    
    test 'The class is a singular value' do
      assert @vcard.has_property?(:class)
      assert_equal 'Public', @vcard[:class]
    end
    
    test 'The geo is a singular value' do
      assert_respond_to @vcard, :geo
      assert @vcard.has_property?(:geo)
    end
    
    test 'The rev is a singular value' do
      assert @vcard.has_property?(:rev)
      assert_equal 1, @vcard.rev.mon
      assert_equal 1, @vcard.rev.day
    end
    
    test 'The role is a singular value' do
      assert @vcard.has_property?(:role)
      assert_equal 'Designer', @vcard.role[0]
    end
    
    test 'The sort-string is a singular value' do
      assert @vcard.has_property?(:sort_string)
      assert_equal 'John', @vcard.sort_string
    end
    
    test 'The tz is a singular value' do
      assert @vcard.has_property?(:tz)
      assert_equal Time.now.utc_offset, @vcard.tz.utc_offset
    end
    
    test 'The uid is a singular value' do
      assert @vcard.has_property?(:uid)
      assert_equal 'com.johndoe/profiles/johndoe', @vcard.uid
    end 
  end
  
  # http://www.ufxtract.com/testsuite/hcard/hcard2.htm
  describe 'multiple occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard2.html')
      @vcard ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The adr (address) is a optional multiple value' do
      assert @vcard.has_property?(:adr)
    end
    
    test 'The email is a optional multiple value' do
      assert @vcard.has_property?(:email)
    end
    
    test 'The org is a optional multiple value' do
      assert @vcard.has_property?(:org)
    end
    
    test 'The tel is a optional multiple value' do
      assert @vcard.has_property?(:tel)
    end
    
    test 'The agent is a optional multiple value' do
      assert @vcard.has_property?(:agent)
      assert_equal 'Dave Doe', @vcard.agent[1]
    end
    
    test 'The category is a optional multiple value' do
      assert @vcard.has_property?(:category)
      assert_equal 'development', @vcard.category[1]
    end
    
    test 'The key is a optional multiple value' do
      assert @vcard.has_property?(:key)
      assert_equal "hd02$Gfu*d%dh87KTa2=23934532479", @vcard.key
    end
    
    test 'The key is a optional multiple value' do
      assert @vcard.has_property?(:label)
      assert_equal "West Street, Brighton, United Kingdom", @vcard.label[1].split("\n").collect {|i| i.strip }.join(' ')
    end
    
    test 'The label is a optional multiple value' do
      assert @vcard.has_property?(:label)
      assert_equal "West Street, Brighton, United Kingdom", @vcard.label[1].split("\n").collect {|i| i.strip }.join(' ')
    end
    
    test 'The logo is a optional multiple value' do
      assert @vcard.has_property?(:logo)
      assert_equal "../images/logo.gif", @vcard.logo[1]
    end
    
    test 'The mailer is a optional multiple value' do
      assert @vcard.has_property?(:mailer)
      assert_equal "Outlook 2007", @vcard.mailer[1]
    end
    
    test 'The nickname is a optional multiple value' do
      assert @vcard.has_property?(:nickname)
      assert_equal "Lost boy", @vcard.nickname[1]
    end
    
    test 'The note is a optional multiple value' do
      assert @vcard.has_property?(:note)
      assert_equal "It can be a real problem booking a hotel room with the name John Doe.", @vcard.note[1]
    end
    
    test 'The photo is a optional multiple value' do
      assert @vcard.has_property?(:photo)
      assert_equal "../images/photo.gif", @vcard.photo[0]
    end
    
    test 'The sound is a optional multiple value' do
      assert @vcard.has_property?(:sound)
      assert_equal 'Pronunciation of my name', @vcard.sound[0]
    end
    
    test 'The title is a optional multiple value' do
      assert @vcard.has_property?(:title)
      assert_equal 'Owner', @vcard.title[1]
    end
    
    test 'The url is a optional multiple value' do
      assert @vcard.has_property?(:url)
      assert_equal "http://www.webfeetmedia.com/", @vcard.url[1]
    end   
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard3.htm
  describe 'adr single and multiple occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard3.html')
      @vcard ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The type is a optional multiple value.' do
      assert @vcard.adr[0].type[0].eql?(:work)
    end
    
    test 'The post-office-box is a optional singular value' do
      assert_equal 'PO Box 46', @vcard.adr[0].post_office_box
    end
    
    test 'The street-address is a optional multiple value' do
      assert_equal 'West Street', @vcard.adr[0].street_address[1]
    end
    
    test 'The extended-address is a optional singular value' do
      assert_equal 'Suite 2', @vcard.adr[0].extended_address[0]
    end
    
    test 'The region is a optional singular value' do
      assert_equal 'East Sussex', @vcard.adr[0].region[0]
    end
    
    test 'The locality is a optional singular value' do
      assert_equal 'Brighton', @vcard.adr[0].locality[0]
    end
    
    test 'The postal-code is a optional singular value' do
      assert_equal 'BN1 3DF', @vcard.adr[0].postal_code
    end
    
    test 'The country-name is a optional singular value' do
      assert_equal 'United Kingdom', @vcard.adr[0].country_name[0]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard4.htm
  describe 'n single and multiple occurence test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard4.html')
      @vcard ||= @@klass.parse_first(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The honorific-prefix is a optional multiple value' do
      assert_equal 'Dr', @vcard.n[:honorific_prefix][0]
    end
    
    test 'The given-name is a optional multiple value' do
      assert_equal 'John', @vcard.n[:given_name][0]
    end
    
    test 'The additional-name is a optional multiple value' do
      assert_equal 'Peter', @vcard.n[:additional_name][0]
    end
    
    test 'The family-name is a optional multiple value' do
      assert_equal 'Doe', @vcard.n[:family_name][0]
    end
    
    test 'The honorific-suffix is a optional multiple value' do
      assert_equal 'PHD', @vcard.n[:honorific_suffix][1]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard6.htm
  describe 'extracting email addresses text' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard6.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'collect the email address from href attribute' do
      assert_equal 'john@example.com', @vcard[0].email[0]
    end
    
    test 'Where a type is specified, but the value is not then the node text is the value' do
      assert @vcard[1].email[0].has_key?(:internet)
      assert_equal 'john@example.com', @vcard[1].email[0].values.first
    end
    
    should 'collect the email address from the node text' do
      assert_equal 'john@example.com', @vcard[2].email[0]
    end
    
    should 'find the type value. types are case insensitive' do
      assert_equal :internet, @vcard[3].email[1][:type]
    end
    
    should 'not contain querystring "?subject=parser-test"' do
      assert_equal 'john@example.com', @vcard[5].email[0]
    end
    
    test 'Where a type is specified, but the value is not then the node text is the value' do
      assert_equal 'john@example.com', @vcard[6].email[0][:value]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard7.htm
  describe 'extracting tel number test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard7.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'collect the telephone number from the node text' do
      assert_equal '01273 700100', @vcard[0].tel[0]
    end
    
    should 'collect the telephone number from a descendant node with value property' do
      assert_equal "01273 700100", @vcard[1].tel[0][:value]
    end
    
    should 'find the type value' do
      assert @vcard[2].tel.first[:type].include?(:pcs)
    end
    
    test 'Where a type is specified, but the value is not then the node text is the value' do
      assert_equal '01273 700301', @vcard[4].tel[0][:value]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard8.htm
  describe 'extracting URLs test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard8.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'collect the URL from the a element' do
      assert_equal 'http://example.com/johndoe/', @vcard.first.url[0]
    end
    
    should 'collect the URL from the area element' do
      assert_equal 'http://example.com/johndoe/', @vcard[1].url[0]
    end
    
    should 'collect the URL of the image element' do
      assert_equal 'http://ufxtract.com/testsuite/images/photo.gif', @vcard[2].photo[0]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard5.htm
  describe 'multiple values in class attribute test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard5.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'find given-name value even if class attribute has multiple values' do
      assert_equal 'John', @vcard[0].n[:given_name][0]
    end
    
    should 'find category value even if class and rel attribute have multiple values' do
      assert_equal 'development', @vcard[0].category[1]
    end
    
    should 'find rev value even if class attribute has multiple values' do
      assert @vcard[0].has_property?(:rev)
      assert_equal 2008, @vcard[0].rev.year
      assert_equal 1, @vcard[0].rev.mon
      assert_equal 1, @vcard[0].rev.day
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard11.htm
  describe 'img element test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard11.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The fn value should be taken from the alt attribute on a img element' do
      assert_equal 'John Doe', @vcard[0].fn
    end
    
    test 'The given-name value should implied from the alt attribute' do
      assert_equal 'John', @vcard[1].n[:given_name][0]
    end
    
    test 'The family-name value should implied from the alt attribute' do
      assert_equal 'Doe', @vcard[2].n[:family_name][0]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard12.htm
  describe 'abbr element test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard12.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'take the value from the abbr title attribute' do
      assert_equal 'John Doe', @vcard[0].fn
      assert_equal 'Mister', @vcard[0].n[:honorific_prefix][0]
      assert_equal 'Jonathan', @vcard[0].n[:given_name][0]
      assert_equal 'John', @vcard[0].n[:additional_name][0]
      assert_equal 'JJ', @vcard[0].nickname[0]
      assert_equal '123 Fake Street', @vcard[0].adr[0][:street_address][0]
      assert @vcard[0].adr[0][:type][0].eql?(:work)
      assert_equal "415.555.1234", @vcard[0].tel[0]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard9.htm
  describe 'extracting geo singular and paired values test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard9.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    should 'find latitude value from single element' do
      assert_equal '37.77', @vcard[0].geo[:latitude]
    end
    
    should 'extract latitude value from paired value' do
      assert_equal '37.77', @vcard[1].geo[:latitude]
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard99.htm
  describe 'implied n optimization test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard99.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The given-name value is implied from the fn value' do
      assert_equal 'Ryan', @vcard[0].n[:given_name]
      assert_equal 'Ryan', @vcard[1].n[:given_name]
      assert_equal 'Ryan', @vcard[2].n[:given_name]
      assert_equal 'Brian', @vcard[3].n[:given_name]
      assert_equal 'Ryan', @vcard[4].n[:given_name]
      assert_equal 'R', @vcard[5].n[:given_name]
      assert_equal 'King', @vcard[6].n[:given_name]
    end
    
    test 'The family-name value is implied from the fn value' do
      assert_equal 'King', @vcard[0].n[:family_name]
      assert_equal 'King', @vcard[1].n[:family_name]
      assert_equal 'King', @vcard[2].n[:family_name]
      assert_equal 'Suda', @vcard[3].n[:family_name]
      assert_equal 'King', @vcard[4].n[:family_name]
      assert_equal 'King', @vcard[5].n[:family_name]
      assert_equal 'R', @vcard[6].n[:family_name]
    end
    
    test 'The given name property should be missing' do
      assert !@vcard[7].has_property?(:n)
      assert !@vcard[8].has_property?(:n)
    end
    
    test 'The family name property should be missing' do
      assert !@vcard[7].has_property?(:n)
      assert !@vcard[8].has_property?(:n)
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard17.htm
  describe 'implied organization-name optimization test' do
    def self.before_all
      @doc ||= test_fixture('hcard/hcard17.html')
      @vcard ||= @@klass.parse(@doc)
    end
    
    setup do
      @vcard = self.class.before_all
    end
    
    test 'The organization-name value is implied from the org value' do
      assert_equal 'World Wide Web Consortium', @vcard[0].org[0][:organization_name]
      assert_equal 'World Wide Web Consortium', @vcard[1].org[0][:organization_name]
      assert_equal 'World Wide Web Consortium', @vcard[2].org[0][:organization_name]
      assert_equal 'World Wide Web Consortium', @vcard[3].org[0][:organization_name]
      assert_equal 'World Wide Web Consortium', @vcard[4].org[0][:organization_name]
    end
    
    test 'The organization name value' do
      assert_equal 'World Wide Web Consortium', @vcard[5].org[0][:organization_name]
      assert_equal 'World Wide Web Consortium', @vcard[6].org[0][:organization_name]
    end
  end

end