require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RelLicenseTest < Test::Unit::TestCase
  setup do
    @html = get_fixture('rel_license.html')
    @doc = Nokogiri::HTML.parse(@html)
  end
  
  describe 'Class' do    
    should 'find itself in a document' do
      assert_equal 2, Prism::Microformat::RelLicense.find_in(@doc).count
    end
  end
  
  describe 'Instance' do
    setup do
      @klass = Prism::Microformat::RelLicense
      @node = @klass.find_in(@doc).first
    end
    
    should 'have a license' do
      test = @klass.new(@node)
      assert_respond_to test, :license
    end
    
    should 'parse the license out of the node' do
      test = @klass.new(@node)
      assert_equal 'http://creativecommons.org/licenses/by/2.0/', test.license
    end
    
    should 'be the license when converted to a string' do
      test = @klass.new(@node)
      assert_equal test.license, test.to_s
    end
  end
end