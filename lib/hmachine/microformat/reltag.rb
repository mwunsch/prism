module HMachine
  module Microformat
    class RelTag < POSH::Base
      WIKI_URL = "http://microformats.org/wiki/rel-tag"
      
      XMDP = 'http://microformats.org/profile/rel-tag'
      
      search {|doc| doc.css('a[rel~="tag"]') }
      
      validate {|a| a['rel'] && a['rel'].split(' ').include?('tag') }
            
      def tag
        @tag ||= { node['href'].split('/').last => node['href'] }
      end
      
      def name
        tag.keys.to_s
      end
      
      def to_s
        name
      end
      
      def url
        tag.values.to_s
      end
      
      def to_h
        tag
      end
      
    end
  end
end