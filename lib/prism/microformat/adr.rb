module Prism
  module Microformat
    class Adr < POSH
      FRIENDLY_NAME = "adr"
      WIKI_URL = 'http://microformats.org/wiki/adr'
      
      name :adr
                  
      # http://microformats.org/wiki/adr-singular-properties      
      has_one :post_office_box, :postal_code
      has_many :street_address, :locality, :region, :extended_address, :country_name
      
      has_many :type do
        extract do |node|
          value = Pattern::ValueClass.extract_from(node)
          Prism.normalize(value) if value
        end
      end
      
    end
  end
end