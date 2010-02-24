module Prism
  module Pattern
    module ValueClass
      extend Prism
      WIKI_URL = 'http://microformats.org/wiki/value-class-pattern'
      
      search do |element| 
        element.css('.value, .value-title[title]').reject {|val| val.parent.matches?('.value') }
      end
      
      validate {|value| value.matches?('.value, .value-title[title]') }
      
      extract do |node|
        if found_in?(node)
          values = get_values(node)
          normalize_values = values.collect { |val| DateTime.valid?(val) ? DateTime.iso8601(val) : val }.join
          DateTime.valid?(normalize_values) ? DateTime.extract_from(normalize_values) : normalize_values
        elsif Abbr.valid?(node)
          Abbr.extract_from(node)
        else
          get_text(node)
        end
      end
      
      def self.get_values(node)
        find_in(node).collect do |val|
          if ((val.node_name.eql?('img') || val.node_name.eql?('area')) && val['alt'])
            val['alt'].strip
          elsif (val.node_name.eql?('object') && val['data'])
            val['data'].strip
          elsif (Abbr.valid?(val) || val.matches?('.value-title'))
            val['title'].strip
          else
            val.content.strip
          end
        end
      end
      
      def self.get_text(node)
        if ((node.node_name.eql?('img') || node.node_name.eql?('area')) && node['alt'])
          node['alt'].strip
        elsif (node.node_name.eql?('object') && node['data'])
          node['data'].strip
        else
          node.content.strip
        end
      end
      
    end
  end
end