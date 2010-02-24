module Prism
  module Microformat
    class Geo < POSH::Base
      FRIENDLY_NAME = "geo"
      WIKI_URL = 'http://microformats.org/wiki/geo'
      
      name :geo
      
      has_one :latitude do
        search do |geo| 
          lat = geo.css(".#{name}")
          !lat.empty? ? lat : geo
        end
        
        extract do |geo|
          if geo['class'] && geo['class'].split.include?("#{name}")
            Prism::Pattern::ValueClass.extract_from(geo)
          else
            Prism::Pattern::ValueClass.extract_from(geo).split(';')[0]
          end
        end
      end
      
      has_one :longitude do
        search do |geo| 
          long = geo.css(".#{name}")
          !long.empty? ? long : geo
        end
        
        extract do |geo|
          if geo['class'] && geo['class'].split.include?("#{name}")
            Prism::Pattern::ValueClass.extract_from(geo)
          else
            Prism::Pattern::ValueClass.extract_from(geo).split(';')[1]
          end
        end
      end
            
      alias lat latitude
      alias long longitude
      
      def to_google_maps
        "http://maps.google.com/?q=#{latitude},#{longitude}"
      end
      
    end
  end
end