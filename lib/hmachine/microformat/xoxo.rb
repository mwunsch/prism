module HMachine
  module Microformat
    class XOXO < Base
      
      root 'xoxo'
      
      wiki_url 'http://microformats.org/wiki/xoxo'
      
      xmdp 'http://microformats.org/profile/xoxo'
      
      search {|doc| doc.css('ol.xoxo, ul.xoxo, ol.blogroll, ul.blogroll') }
      
      validate {|list| list.matches?('ol.xoxo, ul.xoxo, ol.blogroll, ul.blogroll') }
      
      def self.tree(node)
        tree = []
        node.children.each do |child|
          if child.elem? && 
            case child.node_name
              when 'li'
                if child.children.select {|li| li.elem? }.empty?
                  tree = tree | tree(child)
                else
                  tree << tree(child)
                end
              when 'ol', 'ul'
                tree << tree(child)
              when 'dl'
                definition_list = {}
                keys = child.css('dt')
                keys.each do |key|
                  definition = key.next_element if key.next_element.node_name.eql?('dd')
                  definition_contents = definition.children.select {|dd| dd.elem? }
                  definition_list.merge!({ key.content.strip => (definition_contents.empty? ? definition.content.to_s : tree(definition)) })
                end
                tree << definition_list
              when 'a'
                link = { :url => child['href'], :text => child.content.strip }
                link[:rel] = child['rel'].split(' ') if child['rel']
                link[:type] = child['type'] if child['type']
                link[:title] = child['title'] if child['title']
                tree << link
              else
                child.content.strip
            end
          elsif (child.text? && !child.content.strip.empty?)
            tree << child.content.strip
          end
        end
        tree
      end
      
      def outline
        @outline ||= self.class.tree(node)
      end
      
      def to_a
        outline
      end
      
      def [](index)
        outline[index]
      end
      
      def blogroll?
        node['class'].split(' ').include?('blogroll')
      end
      
      
      
    end
  end
end