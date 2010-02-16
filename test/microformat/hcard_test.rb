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
  end
  
  
  
  
  
  
  
  
  
  

end