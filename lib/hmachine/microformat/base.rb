module HMachine
  module Microformat
    class Base
      
      ROOT_CLASS = ""
      
      def self.validate(node)
        node['class'] == self::ROOT_CLASS
      end
      
      attr_reader :node
      
    end
  end
end