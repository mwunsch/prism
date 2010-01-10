module HMachine
  class Property
    
    # A property should be able to find itself within a node
    # and extract it's own contents.
    # It can possess other properties.
    
    attr_reader :name, :property_of
    
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
    
    def self.normalize(name)
      name.to_s.strip.downcase.intern
    end
    
  end
end