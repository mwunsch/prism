require 'hmachine/property'

module HMachine
  module Microformat
    class Base
      extend HMachine
      
      def self.root(class_name=nil)
        @root = class_name if class_name
        @root
      end
      
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
      
      def self.has_one(*properties,&block)        
        # hCard has_one bday
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