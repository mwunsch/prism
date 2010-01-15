require 'hmachine/property'

module HMachine
  module Microformat
    class Base
      extend HMachine    
            
      # The root class name of the microformat
      def self.root(class_name=nil)
        @root = class_name if class_name
        @root
      end
      
      # The wiki url for the microformat
      def self.wiki_url(url=nil)
        @wiki_url = url if url
        @wiki_url || 'http://microformats.org/wiki'
      end
      
      # Overrides the HMachine search method with a similar method, only
      # defaulting to searching for the root class name
      def self.search(&block)
        @search = block if block_given?
        @search || lambda { |doc| doc.css(".#{root}") }
      end
      
      # Overrides the HMachine validate method with similar, only
      # defaulting to checking against the class of name of the node 
      def self.validate(&block)
        @validate = block if block_given?
        @validate || lambda { |node| node['class'] && node['class'].split(' ').include?(root) }
      end
      
      # Overrides the HMachine extraction method.
      # Instead of getting the contents of a node, this creates
      # a microformat from the node
      def self.extract
        lambda{|node| self.new(node) }
      end
      
      def self.extract_from(node)
        extract.call(node)
      end
      
      # The list of Properties that belong to this Microformat
      def self.properties
        @properties ||= []
      end
      
      def self.requirements
        @requirements ||= []
      end
      
      # Find a property by its named key
      def self.find_property(key)
        @keys ||= properties.collect { |prop| prop.name }
        if @keys.include?(key)
          properties[@keys.index(key)]
        end
      end
      
      def self.[](key)
        find_property(key)
      end
      
      # Create a group of properties with names <tt>names</tt>.
      # The function will further refine each property 
      # and push them on to @properties.
      def self.add_properties(names, function=nil)
        names.collect do |prop|
          property = Property.new(prop)
          function.call(property) if function
          properties << property
          property
        end
      end
      
      # Search for the <tt>property</tt> in <tt>node</tt>,
      # ignoring nested microformats.
      def self.search_for(property, node)
        property.find_in(remove_nested(node))
      end
      
      # Remove a microformat from a node if it is nested.
      def self.remove_nested(node)
        if (find_in(node) != node)
          find_in(node).unlink if found_in?(node)
        end
        node
      end
      
      # Get the first instance of a property within a node
      def self.get_one(property, node)
        elem = remove_nested(node)
        property.parse_first(elem) if property.found_in?(elem)
      end
      
      # Get all the instances of a property within a node
      # If the node extracts as a hash, 
      def self.get_all(property, node)
        elem = remove_nested(node)
        property.parse(elem) if property.found_in?(elem)
      end
      
      # The Microformat Has One Property
      def self.has_one(*property_names,&block)
        block = property_names.pop if (!block && property_names.last.respond_to?(:call))
        props = add_properties(property_names, block)
        props.each do |property|
          one_or_many[:one] << property.name
          define_method property.name do
            self.class.get_one(property, node)
          end
        end
      end
      
      # The Microformat Has Many Properties
      def self.has_many(*property_names,&block)
        block = property_names.pop if (!block && property_names.last.respond_to?(:call))
        props = add_properties(property_names, block)
        props.each do |property|
          one_or_many[:many] << property.name
          define_method property.name do
            self.class.get_all(property, node)
          end
        end
      end
      
      # <tt>has_one!</tt> and <tt>has_many!</tt> (note the bang) add a property without
      # adding an instance method.
      def self.has_one!(*property_names,&block)
        block = property_names.pop if (!block && property_names.last.respond_to?(:call))
        props = add_properties(property_names, block)
        props.each do |property|
          one_or_many[:one] << property.name
        end
      end
      
      def self.has_many!(*property_names,&block)
        block = property_names.pop if (!block && property_names.last.respond_to?(:call))
        props = add_properties(property_names, block)
        props.each do |property|
          one_or_many[:many] << property.name
        end
      end
      
      # Maps Method of Parsing (one or many) to a Property
      def self.one_or_many
        @one_or_many ||= {:one => [], :many => []}
      end
      
      # Given a property name and a node, see how many properties
      # should be parsed (one or all) and parse the node.
      def self.fetch_property_from_node(property_name, node)
        property = find_property(property_name)
        if one_or_many[:one].include?(property_name)
          get_one(property, node) 
        elsif one_or_many[:many].include?(property_name)
          get_all(property, node)
        end
      end
      
      # Define Required properties for the Microformat
      def self.requires(*property_names,&block)
        block ? has_one(property_names,block) : has_one(property_names)
        property_names.each {|property| requirements << property }
      end
      
      def self.requires_at_least_one(*property_names,&block)
        block ? has_many(property_names,block) : has_many(property_names)
        property_names.each {|property| requirements << property }
      end
      
      def self.invalid_msg(msg = nil)
        @msg = msg if msg
        @msg || "This is not a valid Microformat node."
      end
      
      attr_reader :node
      
      def initialize(node)
        raise self.class.invalid_msg unless self.class.valid?(node)
        @node = node
        self.class.requirements.each do |requirement| 
          raise "Invalid Microformat. Missing Requirement: #{requirement}" unless properties.include?(requirement)
        end
      end
      
      def [](property)
        to_h[property]
      end
      
      # Get the properties that exist in this microformat
      def properties
        @properties ||= self.class.properties.collect { |property|
          property.name if property.found_in?(node)
        }.compact
      end
      
      # Convert microformat to a hash
      def to_h
        return @to_h if @to_h
        hash = {}
        properties.each do |property|
          hash[property] = self.class.fetch_property_from_node(property, node)
        end
        @to_h = hash.delete_if {|k,v| !v }
      end
      
      # Convert this microformat node to a string
      def to_s
        node.to_s
      end
      
      # Convert this microformat node to its html representation
      def to_html
        node.to_html
      end
      
    end
  end
end