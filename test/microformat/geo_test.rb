# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'test_helper')

class GeoTest < Test::Unit::TestCase
  setup do
    @klass = Prism::Microformat::Geo
  end
  
  should 'has a latitude and longitude' do
    doc = Nokogiri.parse(%q{
      <div class="geo">GEO: 
       <span class="latitude">37.386013</span>, 
       <span class="longitude">-122.082932</span>
      </div>
    })
    geo = @klass.parse_first(doc)
    assert_respond_to geo, :latitude
    assert_respond_to geo, :longitude
    assert_equal geo.latitude, geo.lat
    assert_equal geo.longitude, geo.long
    assert_equal '-122.082932', geo.long
    assert_equal '37.386013', geo.lat
  end
  
  should 'use the abbreviation design pattern when applicable' do
    doc = Nokogiri.parse(%q{
      <div class="geo">
       <abbr class="latitude" title="37.408183">N 37° 24.491</abbr> 
       <abbr class="longitude" title="-122.13855">W 122° 08.313</abbr>
      </div>
    })
    geo = @klass.parse_first(doc)
    assert_equal "37.408183", geo.lat
    assert_equal "-122.13855", geo.long
  end
  
  should 'use the value class pattern' do
    doc = Nokogiri.parse(%q{
      <div class="geo">GEO: 
       <span class="latitude">Somewhere <span class="value">37.386013</span></span>, 
       <span class="longitude">Far Away <span class="value">-122.082932</span></span>
      </div>
    })
    geo = @klass.parse_first(doc)
    assert_equal '37.386013', geo.lat
    assert_equal '-122.082932', geo.long
  end
  
  should 'spit out a google maps url' do
    doc = Nokogiri.parse(%q{
      <div class="geo">
       <abbr class="latitude" title="37.408183">N 37° 24.491</abbr> 
       <abbr class="longitude" title="-122.13855">W 122° 08.313</abbr>
      </div>
    })
    geo = @klass.parse_first(doc)
    assert_equal "http://maps.google.com/?q=37.408183,-122.13855", geo.to_google_maps
  end
  
  should 'extract lat/long values from paired value' do
    doc = Nokogiri.parse(%q(<abbr class="geo" title="37.77;-122.41">Northern California</abbr>))
    geo = @klass.parse_first(doc)
    assert_respond_to geo, :latitude
    assert_equal '37.77', geo.lat
    assert_equal '-122.41', geo.long
  end
end