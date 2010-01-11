require 'hmachine/microformat'
require 'hmachine/pattern'

module HMachine
  class Property
    
    # A property should be able to find itself within a node
    # and extract it's own contents.
    # It can possess other properties.
    
    # Searches for content using patterns.
    
    attr_reader :name, :property_of, :parsers
    
    def initialize(name, property_of = Microformat::Base)
      @name = self.class.normalize(name)
      @property_of = Microformat.normalize(property_of)
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
    # Can be symbols that match to a Pattern module, or a lambda
    # that returns the contents of a node
    def extract_with(*extraction_patterns)
      @parsers = []
      extraction_patterns.each do |pattern|
        parser = pattern.respond_to?(:call) ? pattern : Pattern.map(pattern).parser
        @parsers << parser
      end
    end
    
    # Try each defined extraction pattern to get the content for the property
    def extract_from(node)
      raise "The property #{name.intern} can not be found in this node" unless found_in?(node.parent)
      return node.content unless parsers 
      content = nil
      parsers.each {|parser| 
        if parser.call(node)
          content = parser.call(node)
          break
        end
      }
      content || node.content
    end
    
    # Parse the node, finding the property, and extract the content from it
    def parse(node)
      if found_in?(node)
        contents = find_in(node).collect {|element| extract_from(element) }
        (contents.length == 1) ? contents.first : contents
      end
    end
    
    def self.normalize(name)
      name.to_s.strip.downcase.intern
    end
    
  end
end