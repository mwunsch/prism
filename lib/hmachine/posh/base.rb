module HMachine
  module POSH
    class Base
      extend HMachine
      
      class << self
        def name(root=nil)
          @name = HMachine.normalize(root) if root
          @name
        end
        
        def selector(css=nil)
          @selector = css if css
          @selector
        end
        
        def parent(owner=nil)
          @parent = owner.respond_to?(:extract) ? owner : HMachine.map(owner) if owner
          @parent
        end
              
        def inherited(subclass)
          inheritable = [:@properties, :@has_one, :@has_many, :@search, :@extract, :@validate]
          inheritable.each do |var|
            subclass.instance_variable_set(var, instance_variable_get(var).dup) if instance_variable_get(var)
          end
        end

        # Instead of getting the contents of a node, this creates
        # a POSH format from the node
        def extract(pattern = nil, &block)
          if !@extract
            if pattern
              @extract = HMachine.map(pattern).extract
            elsif block_given?
              @extract = block
            elsif properties.empty?
              @extract = HMachine::Pattern::ValueClass.extract
            end
          end
          @extract || lambda{|node| self.new(node) } 
        end
        
        def search(&block)
          @search = block if block_given?
          @search || lambda do |node|
            if selector
              node.css(selector)
            elsif name
              node.css(".#{name}".gsub('_','-'))
            else
              node
            end
          end
        end
        
        def validate(&block)
          @validate = block if block_given?
          @validate || lambda {|node| selector ? node.matches?(selector) : found_in?(node.parent) }
        end
        
        def add_property(property_name, &block)
          if property_name.respond_to?(:property_of?)
            property = property_name
          else
            property = Class.new(HMachine::POSH::Base)
            property.name property_name
            property.parent self
            property.instance_eval(&block) if block_given?
          end
          properties[property.name] = property
          property
        end
        
        def properties
          @properties ||= {}
        end

        def [](key)
          properties[key]
        end

        def property_of?(format)
          HMachine.map(format) == parent
        end
        alias child_of? property_of?

        def has_one(*property_names, &block)
          property_names.collect do |name|
            property = has_one!(name, &block)
            define_method property.name do 
              self[property.name]
            end
            property
          end
        end

        def has_many(*property_names, &block)
          property_names.collect do |name|
            property = has_many!(name, &block)
            define_method property.name do 
              self[property.name]
            end
            property
          end
        end

        def has_one!(property_name, &block)
          @has_one ||= []
          property = add_property(property_name, &block)
          @has_one << property
          property
        end

        def has_many!(property_name, &block)
          @has_many ||= []
          property = add_property(property_name, &block)
          @has_many << property
          property
        end
        
        def one
          @has_one
        end
        
        def many
          @has_many
        end

        # Remove a format from a node if it is nested.
        def remove_nested(node)
          if (find_in(node) != node)
            find_in(node).unlink if found_in?(node)
          end
          node
        end
        
        def get_properties(node, props=properties)
          hash ||= {}
          props.each_pair do |key, property|
            hash[key] = if one && one.include?(property)
              property.parse_first(node)
            else
              property.parse(node)
            end
          end
          hash.reject {|key,value| value.nil? }
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
        @to_h ||= self.class.get_properties @first_node, properties
      end
      
      def inspect
        to_h.inspect
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
