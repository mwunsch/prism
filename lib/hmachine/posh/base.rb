module HMachine
  module POSH
    class Base
      extend POSH
      
      def self.inherited(subclass)
        inheritable = [:@properties, :@has_one, :@has_many, :@search, :@extract, :@validate]
        inheritable.each do |var|
          subclass.instance_variable_set(var, instance_variable_get(var).dup) if instance_variable_get(var)
        end
      end
            
      # Instead of getting the contents of a node, this creates
      # a POSH format from the node
      def self.extract
        lambda{|node| self.new(node) }
      end
      
      def self.has_one(*property_names, &block)
        property_names.collect do |name|
          property = has_one!(name, &block)
          define_method property.name do 
            self[property.name]
          end
          property
        end
      end
      
      def self.has_many(*property_names, &block)
        property_names.collect do |name|
          property = has_many!(name, &block)
          define_method property.name do 
            self[property.name]
          end
          property
        end
      end
      
      attr_reader :node, :parent, :source
      
      def initialize(node, parent=nil)
        raise 'Uh OH' unless self.class.valid?(node)
        @node = node
        @source = node.document.url if node.document.url
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
        @to_h ||= self.class.property_hash(@first_node, properties)
      end
      
      def has_property?(key)
        to_h.has_key?(key)
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
