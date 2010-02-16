module HMachine
  module Microformat
    class Geo < POSH::Base
      WIKI_URL = 'http://microformats.org/wiki/geo'
      
      search {|doc| doc.css('.geo') }
      
      validate {|geo| geo.matches?('.geo') }
            
      has_one :latitude, :longitude
      alias lat latitude
      alias long longitude
      
      def to_google_maps
        "http://maps.google.com/?q=#{latitude},#{longitude}"
      end
      
    end
  end
end