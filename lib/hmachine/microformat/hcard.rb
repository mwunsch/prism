module HMachine
  module Microformat
    class HCard < Base
      ROOT_CLASS = 'vcard'
      
      root ROOT_CLASS      
      wiki_url "http://microformats.org/wiki/hcard"

      def initialize(node)
        raise "hCard not found in node" unless self.class.validate(node)
        @node = node
      end
      
    end
  end
end