module HMachine
  class Property
    include HMachine
    
    attr_reader :name, :property_of
    
    def initialize(name, owner = :base)
      @name = HMachine.normalize(name)
      @owner = owner
      @property_of = HMachine.map(owner)
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
        sub_property = self.class.new(property, @owner)
        sub_property.belongs_to self
        yield sub_property if block_given?
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