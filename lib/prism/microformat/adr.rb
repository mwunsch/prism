module Prism
  module Microformat
    class Adr < POSH
      FRIENDLY_NAME = "adr"
      WIKI_URL = 'http://microformats.org/wiki/adr'
      
      name :adr
                  
      # http://microformats.org/wiki/adr-singular-properties      
      # Note that some of these properties have different singular or
      # multiple use to the microformat test-suite used elsewhere, such as from:
      # http://ufxtract.com/testsuite/hcard/hcard3.htm
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
