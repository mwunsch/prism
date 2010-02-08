module HMachine
  class Property
    include HMachine
    
    attr_reader :name, :property_of
    
    def initialize(name, property_of = :base)
      @name = HMachine.normalize(name)
      @property_of = property_of.respond_to?(:extract) ? property_of : HMachine.map(property_of)   
      search {|node| node.css(".#{@name}") }
    end
    
    def [](subproperty)
      if !subproperties.empty?
        subproperties[subproperty]
      end
    end
    
    # Is this a property of microformat?
    def property_of?(microformat)
      HMachine.map(microformat) == property_of
    end
    
    def subproperties(*properties)
      @subproperties ||= {}
      properties.each do |property|
        sub_property = self.class.new(property, self)
        yield sub_property if block_given?
        @subproperties[property] = sub_property
      end
      @subproperties
    end
    
  end
end