module HMachine
  module Pattern
    module ValueClass
      extend HMachine
      WIKI_URL = 'http://microformats.org/wiki/value-class-pattern'
      
      search do |element| 
        element.css('.value, .value-title[title]').reject {|val| val.parent.matches?('.value') }
      end
      
      validate {|value| value.matches?('.value, .value-title[title]') }
      
      extract do |node|
        if found_in?(node)
          values = get_values(node)
          values.join
        else
          node.content.strip
        end
      end
      
      def self.datetime(value)
        DateTime.valid?(value) ? DateTime.iso8601(value) : value
      end
      
      def self.get_values(node)
        find_in(node).collect do |val|
          if (val.node_name.eql?('img') || val.node_name.eql?('area')) && val['alt']
            val['alt']
          elsif Abbr.valid?(val)
            val['title']
          else
            val.content.strip
          end
        end
      end
      
    end
  end
end