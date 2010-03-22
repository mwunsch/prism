module Prism
  class POSH
    class Anchor < POSH
      
      selector "a"
            
      has_one :url do
        search {|node| node }
        extract {|node| node['href'] }
      end
      alias href url
      
      has_one :text do
        search {|node| node }
      end
      alias content text
      
      has_one :rel do
        search {|node| node }
        extract {|node| node['rel'].split }
      end
      alias relationship rel
      
      has_one :title do
        search {|node| node }
        extract {|node| node['title'] }
      end
      
      has_one :type do
        search {|node| node }
        extract {|node| node['type'] }
      end
      
      def to_s
        text
      end
      
    end
  end
end