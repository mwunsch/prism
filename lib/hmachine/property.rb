require 'hmachine'

module HMachine
  class Property
    include HMachine
    
    attr_reader :name, :property_of
    
    def initialize(name, property_of = Microformat::Base)
      @name = HMachine.normalize(name)
      @property_of = Microformat.normalize(property_of)
      @search = lambda {|node| node.css(".#{@name}")}
    end
    
    # Is this a property of microformat?
    def property_of?(microformat)
      Microformat.normalize(microformat) == property_of
    end
    
  end
end