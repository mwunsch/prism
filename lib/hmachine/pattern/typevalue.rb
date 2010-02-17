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
          type_value = {}
          if type.respond_to?(:collect)
            type.each do |key|
              type_value[key] = get_value(node)
            end
          else
            type_value[type] = get_value(node)
          end
          type_value
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