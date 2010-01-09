module HMachine
  module Microformat
    class Base
            
      def self.validate(node)
        node['class'] == self::ROOT_CLASS
      end
      
      def self.wiki_url
        self::WIKI_URL
      end
      
      attr_reader :node
      
    end
  end
end