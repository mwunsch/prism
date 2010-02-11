module HMachine
  module Microformat
    class RelLicense < POSH::Anchor
      WIKI_URL = 'http://microformats.org/wiki/rel-license'
      XMDP = 'http://microformats.org/profile/rel-license'
      
      search {|doc| doc.css('a[rel~="license"], link[rel~="license"]') }
      
      validate {|a| a['rel'] && a['rel'].split(' ').include?('license') }
                  
      def license
        @license ||= node['href']
      end
      
      def to_s
        license
      end
      
    end
  end
end