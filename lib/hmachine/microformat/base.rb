module HMachine
  module Microformat
    class Base
      
      # Validates that the node is a microformat
      def self.validate(node)
        validator.call(node)
      end
      
      # Define a function that tests to make sure a given node contains
      # the microformat. Must return truthy
      def self.validator(&block)
        @validator = block if block_given?
        @validator || lambda { |node| node['class'] == self.root }
      end
      
      # Define a function that takes a Nokogiri document 
      # and search it for the microformat
      def self.search(&block)
        @search = block if block_given?
        @search || lambda { |doc| doc.css(".#{self.root}") }
      end
      
      # Performs a search for the microformat in a given Nokogiri::XML::Node
      # returns a Nokogiri::XML::NodeSet
      def self.find_in(document)
        search.call(document)
      end
      
      def self.root(class_name=nil)
        @root = class_name if class_name
        @root
      end
      
      def self.wiki_url(url = nil)
        @wiki_url ||= url
      end
      
      def self.has_one(property)
        # hCard has_one bday
      end
      
      def self.has_many(property)
        # hCard has_many email
      end
      
      def self.requires(property)
        @requirements ||= []
        # hCard requires fn
      end
      
      def self.requirements
        @requirements
      end
      
      # Searches for the property in the microformat avoiding nested microformats
      # returns a Nokogiri::XML::NodeSet
      def self.search_for(property,node)
        search = self.find_in(node)
        search.unlink unless (search == node)
        node.css(".#{property}")
      end
      
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