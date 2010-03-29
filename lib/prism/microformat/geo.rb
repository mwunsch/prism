module Prism
  module Microformat
    class Geo < POSH
      FRIENDLY_NAME = "geo"
      WIKI_URL = 'http://microformats.org/wiki/geo'
      
      name :geo
      
      has_one :latitude, :longitude do
        search do |geo| 
          coord = geo.css(".#{name}")
          !coord.empty? ? coord : geo
        end
        
        extract do |geo|
          if geo['class'] && geo['class'].split.include?("#{name}")
            Prism::Pattern::ValueClass.extract_from(geo)
          else
            coords = Prism::Pattern::ValueClass.extract_from(geo).split(';')
            if name.eql?(:latitude)
              coords[0]
            elsif name.eql?(:longitude)
              coords[1]
            end
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