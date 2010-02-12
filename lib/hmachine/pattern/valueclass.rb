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
          if find_in(node).first.matches?('.value-title[title]')
            find_in(node).first['title']
          else
            find_in(node).collect { |val|
              if Abbr.valid?(val)
                Abbr.extract_from(val)
              elsif ((val.node_name.eql?('img') || val.node_name.eql?('area')) && val['alt'])
                val['alt']
              else
                val.content.strip
              end            
            }.join
          end
        else
          node.content.strip
        end
      end
      
    end
  end
end