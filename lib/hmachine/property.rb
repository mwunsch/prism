require 'hmachine'

module HMachine
  class Property
    include HMachine
    
    attr_reader :name, :property_of
    
    def initialize(name, property_of = :base)
      @name = HMachine.normalize(name)
      @property_of = Microformat.normalize(property_of)
      search {|node| node.css(".#{@name}")}
    end
    
    def [](subproperty)
      subproperties[subproperty] unless subproperties.empty?
    end
    
    # Is this a property of microformat?
    def property_of?(microformat)
      Microformat.normalize(microformat) == property_of
    end
    
    def subproperties(*properties, &block)
      @subproperties ||= {}
      properties.each do |property|
        sub_property = self.class.new(property, property_of)
        sub_property.belongs_to self
        block.call(sub_property) if block_given?
        @subproperties[property] = sub_property
      end
      @subproperties
    end
    
    def belongs_to(property = nil)
      @belongs_to = property if property
      @belongs_to
    end
    
  end
end