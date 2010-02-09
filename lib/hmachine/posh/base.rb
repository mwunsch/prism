module HMachine
  module POSH
    class Base
      extend POSH
      
      # Instead of getting the contents of a node, this creates
      # a POSH format from the node
      def self.extract
        lambda{|node| self.new(node) }
      end
      
      def self.has_one(*property_names, &block)
        property_names.collect do |name|
          property = has_one!(name, block)
          define_method property.name do 
            self[property.name]
          end
          property
        end
      end
      
      def self.has_many(*property_names, &block)
        property_names.collect do |name|
          property = has_many!(name, block)
          define_method property.name do 
            self[property.name]
          end
          property
        end
      end
      
      attr_reader :node, :parent
      
      def initialize(node, parent=nil)
        raise 'Uh OH' unless self.class.valid?(node)
        @node = node
        @parent = parent if parent
        @first_node = self.class.remove_nested(node.dup)
      end
      
      def [](property_key)
        to_h[property_key]
      end
      
      def properties
        @properties ||= self.class.properties.reject { |key, property|
          !property.found_in?(@first_node)
        }
      end
      
      def to_h
        return @to_h if @to_h
        @to_h = {}
        has_one = self.class.instance_variable_get(:@has_one)
        properties.each_pair do |key, property|
          @to_h[key] = if (has_one && has_one.include?(property))
            property.parse_first(@first_node)
          else
            property.parse(@first_node)
          end
        end
        @to_h
      end
      
      def to_s
        node.to_s
      end
      
      def to_html
        node.to_html
      end

    end
  end
end
