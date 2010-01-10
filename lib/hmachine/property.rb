module HMachine
  class Property
    
    attr_reader :name
    
    def initialize(name)
      @name = self.class.normalize(name)
    end
    
    def self.normalize(name)
      name.to_s.strip.downcase.intern
    end
    
  end
end