module HMachine
  module POSH
    class Base
      extend HMachine

      # Instead of getting the contents of a node, this creates
      # a POSH format from the node
      def self.extract
        lambda{|node| self.new(node) }
      end

      # Remove a format from a node if it is nested.
      def self.remove_nested(node)
        if (find_in(node) != node)
          find_in(node).unlink if found_in?(node)
        end
        node
      end
      
      attr_reader :node
      
      def initialize(node)
        raise 'Uh OH' unless self.class.valid?(node)
        @node = node
      end

    end
  end
end
