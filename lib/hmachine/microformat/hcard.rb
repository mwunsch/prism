module HMachine
  module Microformat
    class HCard < Base
                  
      root 'vcard'    
      wiki_url "http://microformats.org/wiki/hcard"
      invalid_msg "Not a valid hCard."
      
      has_one :fn
      
      has_one :n do |n|
        # n.subproperties :family_name, :given_name, :additional_name, 
        #                 :honorific_prefix, :honorific_suffix
      end

      has_many :adr do |adr|
        # adr.subproperties :post_office_box, :extended_address, :street_address, :locality,
        #                   :region, :postal_code, :country_name, :type, :value
      end

      has_many :agent, :category, :key, :label, :logo, :mailer, :nickname,
               :note, :photo, :role, :sound, :title, :url
               
      has_many :email do |email|
        # email.subproperties :type, :value
      end
      
      has_many :tel do |tel|
        # tel.subproperties :type, :value
      end
      
      has_many :geo do |geo|
        # geo.subproperties :latitude, :longitude
      end
      
      has_many :org do |org|
        # org.subproperties :organization_name, :organization_unit
      end
      
      has_one 'bday', 'tz', 'geo', 'sort-string', 'uid', 'rev'
      # Causing a Segmentation Fault => :class
            
    end
  end
end