module HMachine
  module Pattern
    
    def self.map(name)
      case name.to_s.strip.downcase.intern
        when :value_class, :valueclass
          ValueClass
        else
          raise "#{name} is not a recognized markup design pattern."
      end
    end
    
    module ValueClass
      def self.parser
        lambda { |node| node.content }
      end
    end
    
  end
end