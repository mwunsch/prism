module Prism
  module Microformat
    class XOXO < POSH
      FRIENDLY_NAME = "XOXO"
      WIKI_URL = 'http://microformats.org/wiki/xoxo'
      XMDP = 'http://microformats.org/profile/xoxo'
      
      selector 'ol.xoxo, ul.xoxo, ol.blogroll, ul.blogroll'
      
      extract {|node| self.new(node) }
      
      # Seriously ugly WTF
      def self.build_outline(node)
        tree = []
        node.children.each do |child|
          if child.elem? && 
            case child.node_name
              when 'li'
                if child.children.select {|li| li.elem? }.empty?
                  tree = tree | build_outline(child)
                else
                  tree << build_outline(child)
                end
              when 'ol', 'ul'
                tree << build_outline(child)
              when 'dl'
                definition_list = {}
                keys = child.css('dt')
                keys.each do |key|
                  definition = key.next_element if key.next_element.node_name.eql?('dd')
                  definition_contents = definition.children.select {|dd| dd.elem? }
                  definition_list.merge!({ key.content.strip => (definition_contents.empty? ? definition.content.to_s : build_outline(definition)) })
                end
                tree << definition_list
              when 'a'
                link = { :url => child['href'], :text => child.content.strip }
                link[:rel] = child['rel'].split(' ') if child['rel']
                link[:type] = child['type'] if child['type']
                link[:title] = child['title'] if child['title']
                tree << link
              else
                tree << child.content.strip
            end
          elsif (child.text? && !child.content.strip.empty?)
            tree << child.content.strip
          end
        end
        tree
      end
      
      def outline
        @outline ||= self.class.build_outline(node)
      end
      
      def to_a
        outline
      end
      
      def [](index)
        outline[index]
      end
      
      def blogroll?
        node['class'].split.include?('blogroll')
      end      
      
    end
  end
end