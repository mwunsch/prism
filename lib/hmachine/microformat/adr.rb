module HMachine
  module Microformat
    class Adr < POSH::Base
      WIKI_URL = 'http://microformats.org/wiki/adr'
      
      search {|doc| doc.css('.adr') }
      
      validate {|geo| geo.matches?('.adr') }
            
      # http://microformats.org/wiki/adr-singular-properties      
      has_one :post_office_box, :postal_code
      has_many :street_address, :locality, :region, :extended_address, :country_name
      
    end
  end
end