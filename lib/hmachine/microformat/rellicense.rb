module HMachine
  module Microformat
    class RelLicense < Base
      
      wiki_url 'http://microformats.org/wiki/rel-license'
      
      search {|doc| doc.css('a[rel~="license"], link[rel~="license"]') }
      
      validate {|a| a['rel'] && a['rel'].include?('license') }
      
      invalid_msg "This is not a Rel License Microformat"
      
      extract {|node| node['href'] }
      
      def license
        @license ||= self.class.extract_from(node)
      end
      
      def to_s
        license
      end
      
    end
  end
end