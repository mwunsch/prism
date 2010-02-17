module HMachine
  module Microformat
    class HCard < POSH::Base
      WIKI_URL = "http://microformats.org/wiki/hcard"
      XMDP = 'http://microformats.org/profile/hcard'
      
      search {|doc| doc.css('.vcard') }
      
      validate {|vcard| vcard.matches?('.vcard') }
      
      has_one :fn, :bday, :tz, :sort_string, :uid, :rev 
      alias birthday bday
      
      has_many :agent, :category, :key, :label,
               :mailer, :nickname, :note, :role, :sound, 
               :title
               
      has_many :logo, :photo, :url do |uri|
        uri.extract :url
      end
      
      has_one :geo do |geo|
        geo.has_one :latitude,  :longitude
        
        geo.extract do |node|
          if geo[:latitude].found_in?(node) && geo[:longitude].found_in?(node)
            Microformat::Geo.extract_from(node)
          else
            coords = Pattern::ValueClass.extract_from(node).split(';')
            {:latitude => coords[0], :longitude => coords[1]}
          end
        end
      end
      
      has_many :email, :tel
      
      has_many :adr do |adr|
        adr.extract do |node|  
          address = Microformat::Adr.extract_from(node)
          address.type ? { address.type => address } : address          
        end
      end
      alias address adr
            
      has_many :org do |org|
        org.has_one :organization_name, :organization_unit
      end
      
      has_one :n do |n|
        n.search do |doc|
          found = doc.css('.n')
          if !found.empty?
            found
          else
            properties[:fn].find_in(doc)
          end
        end
        
        n.has_one :family_name, :given_name, :additional_name,
                  :honorific_prefix, :honorific_suffix
        
        n.extract do |node|
          if node.matches?('.n')
            n.property_hash(node)
          else
            n_optimization(node)
          end
        end  
      end
      
      has_one! :class
      
      # N Optimization from Sumo:
      # http://www.danwebb.net/2007/2/9/sumo-a-generic-microformats-parser-for-javascript
      # See: http://microformats.org/wiki/hcard#Implied_.22n.22_Optimization
      def self.n_optimization(node)
        fn = properties[:fn].parse_first(node.parent)
        org = properties[:org].parse_first(node.parent)
        if (fn != org)
          if (fn =~ /^(\w+) (\w+)$/)
            { :given_name => Regexp.last_match[1],
              :family_name => Regexp.last_match[2] }
          elsif (fn =~ /^(\w+), (\w+)\.?$/)
            { :given_name => Regexp.last_match[2],
              :family_name => Regexp.last_match[1] }
          end
        end
      end
      
      def organization?
        fn == org
      end
      alias company? organization?
            
    end
  end
end