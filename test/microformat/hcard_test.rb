require File.join(File.dirname(__FILE__), '..', 'test_helper')

class HCardTest < Test::Unit::TestCase
  # http://www.ufxtract.com/testsuite/hcard/hcard1.htm
  describe 'single occurence test' do
    setup do
      @html = get_fixture('test-fixture/hcard/hcard1.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
      @klass = HMachine::Microformat::HCard
      @vcard = @klass.parse_first(@doc)
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
      assert_equal 'Designer', @vcard.role
    end
    
    test 'The sort-string is a singular value' do
      assert @vcard.has_property?(:sort_string)
      assert_equal 'John', @vcard.sort_string
    end
    
    test 'The tz is a singular value' do
      assert @vcard.has_property?(:tz)
      assert_equal -18000, @vcard.tz.utc_offset
    end
    
    test 'The uid is a singular value' do
      assert @vcard.has_property?(:uid)
      assert_equal 'com.johndoe/profiles/johndoe', @vcard.uid
    end 
  end
  
  # http://www.ufxtract.com/testsuite/hcard/hcard2.htm
  describe 'multiple occurence test' do
    setup do
      @html = get_fixture('test-fixture/hcard/hcard2.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
      @klass = HMachine::Microformat::HCard
      @vcard = @klass.parse_first(@doc)
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
      assert_equal "../images/photo.gif", @vcard.photo
    end
    
    test 'The sound is a optional multiple value' do
      assert @vcard.has_property?(:sound)
      assert_equal 'Pronunciation of my name', @vcard.sound
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
    setup do
      @html = get_fixture('test-fixture/hcard/hcard3.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
      @klass = HMachine::Microformat::HCard
      @vcard = @klass.parse_first(@doc)
    end
    
    test 'The type is a optional multiple value.' do
      assert @vcard.adr.has_key?(:work)
    end
    
    test 'The post-office-box is a optional singular value' do
      assert_equal 'PO Box 46', @vcard.adr[:work].post_office_box
    end
    
    test 'The street-address is a optional multiple value' do
      assert_equal 'West Street', @vcard.adr[:work].street_address[1]
    end
    
    test 'The extended-address is a optional singular value' do
      assert_equal 'Suite 2', @vcard.adr[:work].extended_address
    end
    
    test 'The region is a optional singular value' do
      assert_equal 'East Sussex', @vcard.adr[:work].region
    end
    
    test 'The locality is a optional singular value' do
      assert_equal 'Brighton', @vcard.adr[:work].locality
    end
    
    test 'The postal-code is a optional singular value' do
      assert_equal 'BN1 3DF', @vcard.adr[:work].postal_code
    end
    
    test 'The country-name is a optional singular value' do
      assert_equal 'United Kingdom', @vcard.adr[:work].country_name
    end
  end
  
  # http://ufxtract.com/testsuite/hcard/hcard4.htm
  describe 'n single and multiple occurence test' do
    setup do
      @html = get_fixture('test-fixture/hcard/hcard4.html')
      @doc = Nokogiri::HTML.parse(@html).css('#uf').first
      @klass = HMachine::Microformat::HCard
      @vcard = @klass.parse_first(@doc)
    end
    
    test 'The honorific-prefix is a optional multiple value' do
      assert_equal 'Dr', @vcard.n[:honorific_prefix]
    end
    
    test 'The given-name is a optional multiple value' do
      assert_equal 'John', @vcard.n[:given_name]
    end
    
    test 'The additional-name is a optional multiple value' do
      assert_equal 'Peter', @vcard.n[:additional_name]
    end
    
    test 'The family-name is a optional multiple value' do
      assert_equal 'Doe', @vcard.n[:family_name]
    end
    
    test 'The honorific-suffix is a optional multiple value' do
      assert_equal 'PHD', @vcard.n[:honorific_suffix][1]
    end
  end
  
  
  
  
  
  
  

end