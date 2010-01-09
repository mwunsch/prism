module HMachine
  module Microformat
    class HCard < Base
      
      validator { |node| node['class'] == self::ROOT_CLASS }
      wiki_url "http://microformats.org/wiki/hcard"
                        
      ROOT_CLASS = "vcard"
      ROOT_SELECTOR = ".#{ROOT_CLASS}"
      
      def initialize(node)
        raise "hCard not found in node" unless self.class.validate(node)
        @node = node
      end
      
      def to_vcard
        # convert to vcard
      end
      
      def self.infer_n_from_fn(fn)
        # ...
      end
      
    end
  end
end