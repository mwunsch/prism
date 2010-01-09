module HMachine
  module Microformat
    class Base
      
      def self.validate(node)
        validator.call(node)
      end
      
      def self.validator(&block)
        @validator = block if block_given?
        @validator || lambda { true }
      end
      
      def self.wiki_url(url = nil)
        @wiki_url ||= url
      end
      
      attr_reader :node
      
      def initialize(node)
        @node = node
      end
      
      def to_s
        node.to_s
      end
      
      def to_html
        node.to_html
      end
      
    end
  end
end