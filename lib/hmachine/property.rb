module HMachine 
  class Property
    include POSH
    
    def initialize(name, parent = :base)
      @name = HMachine.normalize(name)
      @parent = parent.respond_to?(:extract) ? parent : HMachine.map(parent)   
      search {|node| node.css(".#{@name}") }
      extract :valueclass
    end
    
  end
end