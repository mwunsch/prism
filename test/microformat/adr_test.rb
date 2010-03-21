require File.join(File.dirname(__FILE__), '..', 'test_helper')

class AdrTest < Test::Unit::TestCase
  setup do
    @klass = Prism::Microformat::Adr
    @html = %Q{<div class="adr">
     <div class="street-address">665 3rd St.</div>
     <div class="extended-address">Suite 207</div>
     <span class="locality">San Francisco</span>,
     <span class="region">CA</span>
     <span class="postal-code">94107</span>
     <div class="country-name">U.S.A.</div>
    </div>}
    @doc = Nokogiri.parse(@html)
    @adr = @klass.parse_first(@doc)
  end
  
  should 'have a street address' do
    assert @adr.has_property?(:street_address)
    assert_equal '665 3rd St.', @adr.street_address[0]
  end
  
  should 'have an extended address' do
    assert @adr.has_property?(:extended_address)
    assert_equal 'Suite 207', @adr.extended_address[0]
  end
  
  should 'have a locality' do
    assert @adr.has_property?(:locality)
    assert_equal 'San Francisco', @adr.locality[0]
  end
  
  should 'have a region' do
    assert @adr.has_property?(:region)
    assert_equal 'CA', @adr.region[0]
  end
  
  should 'have a postal code' do
    assert @adr.has_property?(:postal_code)
    assert_equal '94107', @adr.postal_code
  end
  
  should 'have a country name' do
    assert @adr.has_property?(:country_name)
    assert_equal 'U.S.A.', @adr.country_name[0]
  end
end