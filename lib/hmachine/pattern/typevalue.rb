module HMachine
  module Pattern
    module TypeValue
      extend HMachine
      
      search do |doc| 
        doc.css('.type').reject {|type| type.parent.matches?('.type') }
      end
      
      extract do |node|
        if found_in?(node)
          element = find_in(node)
          types = element.collect {|type| HMachine.normalize Pattern::ValueClass.extract_from(type.unlink) }
          type = (types.length == 1) ? types.first : types
          {type => get_value(node)}
        else
          get_value(node)
        end
      end
      
      def self.get_value(node)
        if Pattern::URL.valid?(node)
          Pattern::URL.extract_from(node)
        else
          Pattern::ValueClass.extract_from(node)
        end
      end
      
    end
  end
end