module HMachine
  module POSH
    class Anchor < Base
      
      search {|doc| doc.css('a') }
      
      validate {|node| node.elem? && (node.node_name == 'a') }
      
      has_one :url do |url|
        url.search {|node| node }
        url.extract {|node| node['href'] }
      end
      alias href url
      
      has_one :text do |text|
        text.search {|node| node }
        text.extract {|node| node.content.strip }
      end
      alias content text
      
      has_one :rel do |rel|
        rel.search {|node| node }
        rel.extract {|node| node['rel'].split(' ') }
      end
      
      has_one :title do |title|
        title.search {|node| node }
        title.extract {|node| node['title'] }
      end
      
      has_one :type do |type|
        type.search {|node| node }
        type.extract {|node| node['type'] }
      end
      
      def to_s
        text
      end
      
    end
  end
end