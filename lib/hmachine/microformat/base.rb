module HMachine
  module Microformat
    class Base
      
      def self.validator(&block)
        @validator = block if block_given?
        @validator
      end   
      
      def self.validate(node)
        validator.call(node)
      end
      
      def self.wiki_url(url = nil)
        @wiki_url ||= url
      end
      
      attr_reader :node
      
    end
  end
end