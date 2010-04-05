module Prism
  module Microformat
    class RelTag < POSH::Anchor
      FRIENDLY_NAME = "rel-tag"
      WIKI_URL = "http://microformats.org/wiki/rel-tag"      
      XMDP = 'http://microformats.org/profile/rel-tag'
      
      selector 'a[rel~="tag"]'
      
      validate {|a| a['rel'] && a['rel'].split.include?('tag') }
            
      def tag
        @tag ||= { node['href'].split('/').last => node['href'] }
      end
      
      def name
        tag.keys.join
      end
      
      def to_s
        name
      end
      
      def url
        tag.values.join
      end
      
      def to_h
        tag
      end
      
      def inspect
        "<#{self.class}:#{hash}: '#{tag}'>"
      end
      
    end
  end
end