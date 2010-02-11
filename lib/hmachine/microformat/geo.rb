module HMachine
  module Microformat
    class Geo < POSH::Base
      WIKI_URL = 'http://microformats.org/wiki/geo'
      
      search {|doc| doc.css('.geo') }
      
      validate {|geo| geo.matches?('.geo') }
      
      has_one :latitude do |lat|
        lat.extract do |node|
          if Pattern::ValueClass.found_in?(node)
            Pattern::ValueClass.extract_from(node)
          else
            Pattern::Abbr.extract_from(node)
          end
        end
      end
      alias lat latitude
      
      has_one :longitude do |long|
        long.extract do |node|
          if Pattern::ValueClass.found_in?(node)
            Pattern::ValueClass.extract_from(node)
          else
            Pattern::Abbr.extract_from(node)
          end
        end
      end
      alias long longitude
      
      def to_google_maps
        "http://maps.google.com/?q=#{latitude},#{longitude}"
      end
      
    end
  end
end