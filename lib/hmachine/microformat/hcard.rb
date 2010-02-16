module HMachine
  module Microformat
    class HCard < POSH::Base
      WIKI_URL = "http://microformats.org/wiki/hcard"
      XMDP = 'http://microformats.org/profile/hcard'
      
      search {|doc| doc.css('.vcard') }
      
      validate {|vcard| vcard.matches?('.vcard') }
      
      has_one :fn
      
      has_one :org do |org|
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
      
      # has_one :fn
      # 
      # has_one :n do |n|
      #   n.subproperties :family_name, :given_name, :additional_name, 
      #                   :honorific_prefix, :honorific_suffix
      # end
      # 
      # has_many :adr do |adr|
      #   adr.subproperties :post_office_box, :extended_address, :street_address, :locality,
      #                     :region, :postal_code, :country_name, :type, :value
      # end
      # 
      # has_many :agent, :category, :key, :label, :logo, :mailer, :nickname,
      #          :note, :photo, :role, :sound, :title, :url
      #          
      # has_many :email do |email|
      #   email.subproperties :type, :value
      # end
      # 
      # has_many :tel do |tel|
      #   tel.subproperties :type, :value
      # end
      # 
      # has_many :geo do |geo|
      #   geo.subproperties :latitude, :longitude
      # end
      # 
      # has_many :org do |org|
      #   org.subproperties :organization_name, :organization_unit
      # end
      # 
      # has_one :bday, :tz, :geo, :sort_string, :uid, :rev, :_class 
      # # Calling this _class, because class causes a seg fault
            
    end
  end
end