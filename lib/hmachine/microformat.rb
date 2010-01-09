require 'hmachine/microformat/base'
require 'hmachine/microformat/hcard'

module HMachine
  module Microformat
    
    def self.find_hcard(html)
      doc = HMachine.get_document(html)
      find_in_node(HCard, doc)
    end
    
    def self.find_all(html)
      find_hcard html
    end
    
    def self.find_in_node(microformat, node)
      microformats = []
      node.css(microformat::ROOT_SELECTOR).each do |node|
        microformats << create_for_node(microformat, node) if microformat.validate(node)
      end
      microformats
    end
    
    def self.create_for_node(microformat, node)
      return unless microformat.validate(node)
      microformat.new node
    end
    
  end
end