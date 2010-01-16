module HMachine
  module Microformat
    class RelLicense < Base
      
      wiki_url 'http://microformats.org/wiki/rel-license'
      
      xmdp 'http://microformats.org/profile/rel-license'
      
      search {|doc| doc.css('a[rel~="license"], link[rel~="license"]') }
      
      validate {|a| a['rel'] && a['rel'].split(' ').include?('license') }
      
      invalid_msg "This is not a Rel License Microformat"
            
      def license
        @license ||= node['href']
      end
      
      def to_s
        license
      end
      
    end
  end
end