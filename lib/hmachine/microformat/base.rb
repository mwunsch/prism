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
        @validate || lambda { |node| node['class'] == root }
      end
      
      # The list of Properties that belong to this Microformat
      def self.properties
        @properties ||= []
      end
      
      # Create a Property with name <tt>name</tt>.
      # Can further refine with a lambda (should return the property)
      def self.create_property(name, function=nil)
        property = Property.new(name)
        function.call(property) if function
        property
      end
      
      # Create a group of properties with names <tt>names</tt>.
      # The function will further refine each property 
      # and push them on to @properties.
      def self.add_properties(names, function=nil)
        names.collect do |prop|
          property = create_property(prop, function)
          properties << property
          property
        end
      end
      
      # Search for the <tt>property</tt> in <tt>node</tt>,
      # ignoring nested microformats.
      def self.search_for(property, node)
        find_in(node).unlink if found_in?(node)
        property.find_in(node)
      end
      
      def self.has_one(*property_names,&block)
        props = add_properties(property_names, block)
      end
      
      def self.has_many(property)
        # hCard has_many email
      end
      
      def self.requires(property)
        # hCard requires fn
      end
      
      
      

      
      # def self.requirements
      #   @requirements
      # end
      
      # Searches for the property in the microformat avoiding nested microformats
      # returns a Nokogiri::XML::NodeSet
      # def self.search_for(property, node)
      #   search = self.find_in(node)
      #   search.unlink unless (search == node)
      #   node.css(".#{property}")
      # end
      
      attr_reader :node
      
      def initialize(node)
        @node = node
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