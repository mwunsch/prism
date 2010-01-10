require 'hmachine/microformat'
require 'hmachine/pattern'

module HMachine
  class Property
    
    # A property should be able to find itself within a node
    # and extract it's own contents.
    # It can possess other properties.
    
    # Searches for content using patterns.
    
    attr_reader :name, :property_of, :patterns
    
    def initialize(name, property_of = Microformat::Base)
      @name = self.class.normalize(name)
      @property_of = Microformat.normalize(property_of)
      @patterns = []
    end
    
    # Is this a property of microformat?
    def property_of?(microformat)
      Microformat.normalize(microformat) == property_of
    end
    
    # Get/Set a function that defines how to find the Property in a node.
    # The Search function should return a Nokogiri::XML::NodeSet.
    def search(&block)
      @search = block if block_given?
      @search || lambda{ |node| node.css(".#{name}") }
    end
    
    # Search for the Property in a node
    def find_in(node)
      search.call(node)
    end
    
    # Is the property found in node?
    def found_in?(node)
      !find_in(node).empty?
    end
    
    # Define the patterns used to extract contents from node
    def extract_with(*extraction_patterns)
      @patterns = extraction_patterns
    end
    
    # Try each defined extraction pattern to get the content for the property
    def extract_from(node)
      raise "The property #{name.intern} can not be found in this node" unless found_in?(node.parent)
      node.content
    end
    
    def parse(node)
      # if found_in?(node)
      #   find_in(node).each {|element| extract_from element }
      # end     
    end
    
    def self.normalize(name)
      name.to_s.strip.downcase.intern
    end
    
  end
end